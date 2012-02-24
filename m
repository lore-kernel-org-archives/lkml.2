Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab2BXVfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:35:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5449 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2BXVfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:35:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 24 Feb 2012 13:35:09 -0800
From: Stephen Warren <swarren@nvidia.com>
To: "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>,
        "Liam Girdwood (lrg@ti.com)" <lrg@ti.com>, Chris Ball <cjb@laptop.org>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 24 Feb 2012 13:35:08 -0800
Subject: sdmmc controllers without vmmc regulator
Thread-Topic: sdmmc controllers without vmmc regulator
Thread-Index: AczzOybObEspSMPRQWyxiS6LFfMK8w==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCD8C@HQMAIL01.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdhci_add_host() calls regulator_get(..., "vmmc"), which under device-
tree calls of_get_regulator(), which contains:

	regnode = of_parse_phandle(dev->of_node, prop_name, 0);

	if (!regnode) {
		dev_warn(dev, "%s property in node %s references invalid phandle",
				prop_name, dev->of_node->full_name);
		return NULL;
	}

Thus if the vmmc-supply property is missing, because a board has no
regulator for a particular SD controller (power is always on), then
the warning is printed.

Can we eliminate this warning in of_get_regulator(), and let clients
Control whether they warn when a regulator isn't found, if they think
one is mandatory? I think I'd prefer this option; it's consistent with
the non-DT path in regulator_dev_lookup().

Or, should I set up dummy regulators in device tree to cover this case,
such that an SD controller's vmmc-supply always points at a valid phandle.
In which case, I'd have to add DT support to the dummy regulator.

Thanks.

-- 
nvpublic


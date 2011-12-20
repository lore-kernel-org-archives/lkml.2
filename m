Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1LTX6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:58:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13675 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1LTX6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:58:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 20 Dec 2011 15:58:44 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <b29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Tue, 20 Dec 2011 15:58:43 -0800
Subject: RE: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Thread-Topic: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Thread-Index: Acy/PPacJXVw3FbcT8+W9MCERHBz6QANfpzw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF176BE92EE2@HQMAIL01.nvidia.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-2-git-send-email-b29396@freescale.com>
In-Reply-To: <1324402840-32451-2-git-send-email-b29396@freescale.com>
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

Dong Aisheng wrote at Tuesday, December 20, 2011 10:41 AM:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Currently most code to get child count in kernel are almost same,
> add a helper to implement this function for dt to use.

> diff --git a/include/linux/of.h b/include/linux/of.h

> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +	return -ENOSYS;
> +}

Wouldn't it be better to return 0 here? -ENOSYS would be fine if the
function returned an error code, but it's really returning a count, and
other "dummy" functions that return data return 0/NULL already. This
would also allow you to just use the value directly in all cases rather
than having to check for a < 0 error case.

-- 
nvpublic


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2ARQgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:36:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16405 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2ARQg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:36:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Jan 2012 08:36:27 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rakesh Iyer <riyer@nvidia.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Jan 2012 08:36:26 -0800
Subject: RE: [PATCH 1/1] Input: tegra-kbc - remove pre Tegra20 definitions
Thread-Topic: [PATCH 1/1] Input: tegra-kbc - remove pre Tegra20 definitions
Thread-Index: AczVeF+5BK+tJLzERie8xpeePdCsXAAhfwLQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAADCB@HQMAIL01.nvidia.com>
References: <1326842810-12039-1-git-send-email-riyer@nvidia.com>
 <20120118003012.GA27489@core.coreip.homeip.net>
In-Reply-To: <20120118003012.GA27489@core.coreip.homeip.net>
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

Dmitry Torokhov wrote at Tuesday, January 17, 2012 5:30 PM:
> On Tue, Jan 17, 2012 at 03:26:50PM -0800, Rakesh Iyer wrote:
> > Add support for Tegra30 by correcting definitions. This is necessary to
> > make driver useful in Tegra30.
> 
> So what about older versions? There still could be users...

I wonder if there will be problems with this patch; the loop in
tegra_kbc_report_keys() is going to process 8 bits more of the last
register and the loop in tegra_kbc_config_pins() will now touch one
more row and one more column register. I think these loops should be
limited at run-time based on the SoC actually being executed upon?

-- 
nvpublic


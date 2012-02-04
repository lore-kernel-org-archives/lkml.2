Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2BDSZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:25:08 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:64844 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab2BDSZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:25:07 -0500
X-IronPort-AV: E=Sophos;i="4.73,357,1325458800"; 
   d="scan'208";a="142859996"
Date: Sat, 4 Feb 2012 19:25:05 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Wolfram Sang <w.sang@pengutronix.de>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: devm_request_and_ioremap
In-Reply-To: <20120126135135.GD2611@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1202041922070.1974@hadrien>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6> <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien> <20120126110506.GB2611@pengutronix.de> <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6> <20120126112242.GA9401@opensource.wolfsonmicro.com> <alpine.DEB.2.02.1201261439460.1851@localhost6.localdomain6>
 <20120126135135.GD2611@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How important is the name argument to request_mem_region?

devm_request_and_ioremap uses:

name = res->name ?: dev_name(dev);

In trying to introduce uses of devm_request_and_ioremap I thus look for 
res->name and dev_name(dev) as well as the name in the driver structure in
the platform_driver structure.  But sometimes the name is pdev->name, ie 
the name field of the argument to the probe function.  And sometimes it is 
a string that is slightly different than what is in the driver structure.

thanks,
julia

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab0DFFAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:00:06 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:54379 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0DFE77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 00:59:59 -0400
Date: Tue, 6 Apr 2010 08:00:36 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Madhusudhan <madhu.cr@ti.com>
Cc: me@felipebalbi.com, "'kishore kadiyala'" <kishorek.kadiyala@gmail.com>,
       "'Vimal Singh'" <vimal.newwork@gmail.com>, tony@atomide.com,
       svenkatr@ti.com, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, jarkko.lavinen@nokia.com
Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's
 peformance.
Message-ID: <20100406050035.GA32537@gandalf>
Reply-To: me@felipebalbi.com
References: <004701caab40$68b576e0$544ff780@am.dhcp.ti.com>
 <x2q7f9d1ffb1003302307nb8e91be0o55da59c3375f1720@mail.gmail.com>
 <v2yce9ab5791003302327hc67deb3akc7d18146534038f9@mail.gmail.com>
 <h2p7f9d1ffb1003310003z508e21dbqe37b6e1cad425866@mail.gmail.com>
 <003b01cad0f0$6ea78040$544ff780@am.dhcp.ti.com>
 <g2s7f9d1ffb1003312331o149df218g651c3e4349ac9a77@mail.gmail.com>
 <003c01cad1b1$da2cdbf0$544ff780@am.dhcp.ti.com>
 <m2n7f9d1ffb1004050556o1ed2eec8ief66d60fc85f96de@mail.gmail.com>
 <20100405164839.GB17388@gandalf>
 <007c01cad4e4$26c5a700$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007c01cad4e4$26c5a700$544ff780@am.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 05, 2010 at 12:19:29PM -0500, Madhusudhan wrote:
> Since the first if command already checks for the 8-bit the second check
> like >= 4 is definitely not readable in my opinion.

how come ???

> Functionally do you see anything wrong with this patch??

functionally no, but (hypothetical situation) and if on
omap4/5/6/whatever, omap controller supports a bigger bus width then
you'll have to add a line like:

+	if (mmc_slot(host).wires == 16)
+		mmc->caps |= (MMC_CAP_16_BIT_DATA | MMC_CAP_8_BIT_DATA |
+				MMC_CAP_4_BIT_DATA);
-	if (mmc_slot(host).wires == 8)
+	else if (mmc_slot(host).wires == 8)

do you see the problem ?? In my opinion it doesn't scale well.

-- 
balbi

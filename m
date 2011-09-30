Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab1I3Ico (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:32:44 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:43610 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1I3Icl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:32:41 -0400
Date: Fri, 30 Sep 2011 02:32:40 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: Benoit Cousson <b-cousson@ti.com>, parthab@india.ti.com,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, tony@atomide.com, khilman@ti.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <CAP05o4KbVkXgnPc7JonrvURmCpQRgjMK2K_dmjQSKzQufQhjkA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109300227530.12185@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
 <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com> <alpine.DEB.2.00.1109240101120.22872@utopia.booyaka.com> <CAP05o4+uwuFL8XNFG-wmUW8voYQ4kywyU9Qn-Mng7kv=TzZm9w@mail.gmail.com> <alpine.DEB.2.00.1109260844360.13188@utopia.booyaka.com>
 <CAP05o4KbVkXgnPc7JonrvURmCpQRgjMK2K_dmjQSKzQufQhjkA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011, Munegowda, Keshava wrote:

> Thanks paul,
> 
> But In USB Host case, there is a challenge!
> 
> I need both usbhost_48m_fck and usbhost_120m_fck to be turned on when
> I invoke pm_runtime_get_sync ; so there are couple of options to do this
> 
> 1. use clk_get with hard coded  usbhost_120m_fck name in  usbhs driver
>        enable this clock after invoking pm_runtime_get_sync
> 
> 2. add an additional flag in hwmod ; so that pm_runtime_get_sync will enable
>            main clock as well as optional clocks
> 
> please comment on these two approaches..

Looks like you picked approach #1 which is fine with me.  

Here's what I don't understand about how this clock is used, though.  
According to the 34xx TRM vZR Section 24.2.3.1.2 "High-Speed USB Host 
Subsystem Clocks", this is only used to "clock EHCI controller internal 
logic".  So if EHCI is not being used, it would seem to me that this clock 
shouldn't be enabled?  But patch #5 seems to enable and disable it 
unconditionally.  Am I missing something here?


- Paul

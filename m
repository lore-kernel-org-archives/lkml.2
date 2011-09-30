Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1I3Jge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:36:34 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:32887 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075Ab1I3Jgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:36:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1109300227530.12185@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
	<1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
	<1316691479-1849-3-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
	<CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
	<alpine.DEB.2.00.1109240101120.22872@utopia.booyaka.com>
	<CAP05o4+uwuFL8XNFG-wmUW8voYQ4kywyU9Qn-Mng7kv=TzZm9w@mail.gmail.com>
	<alpine.DEB.2.00.1109260844360.13188@utopia.booyaka.com>
	<CAP05o4KbVkXgnPc7JonrvURmCpQRgjMK2K_dmjQSKzQufQhjkA@mail.gmail.com>
	<alpine.DEB.2.00.1109300227530.12185@utopia.booyaka.com>
Date: Fri, 30 Sep 2011 15:06:31 +0530
Message-ID: <CAP05o4JA_pBJUq4qQ6ase41nvznbfLRuvwh02fOhHKWNqie_NA@mail.gmail.com>
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Benoit Cousson <b-cousson@ti.com>, parthab@india.ti.com,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, tony@atomide.com, khilman@ti.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 2:02 PM, Paul Walmsley <paul@pwsan.com> wrote:
> On Wed, 28 Sep 2011, Munegowda, Keshava wrote:
>
>> Thanks paul,
>>
>> But In USB Host case, there is a challenge!
>>
>> I need both usbhost_48m_fck and usbhost_120m_fck to be turned on when
>> I invoke pm_runtime_get_sync ; so there are couple of options to do this
>>
>> 1. use clk_get with hard coded  usbhost_120m_fck name in  usbhs driver
>>        enable this clock after invoking pm_runtime_get_sync
>>
>> 2. add an additional flag in hwmod ; so that pm_runtime_get_sync will enable
>>            main clock as well as optional clocks
>>
>> please comment on these two approaches..
>
> Looks like you picked approach #1 which is fine with me.
>
> Here's what I don't understand about how this clock is used, though.
> According to the 34xx TRM vZR Section 24.2.3.1.2 "High-Speed USB Host
> Subsystem Clocks", this is only used to "clock EHCI controller internal
> logic".  So if EHCI is not being used, it would seem to me that this clock
> shouldn't be enabled?  But patch #5 seems to enable and disable it
> unconditionally.  Am I missing something here?

OK. are you suggesting that this clock should be enabled/disabled; only
if atleast one port is selected for ehci?

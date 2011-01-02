Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1ABSte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 13:49:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19617 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1ABStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 13:49:33 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6214"; a="68768903"
From: David Brown <davidb@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nicolas Pitre <nico@fluxnic.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Daniel Walker <dwalker@codeaurora.org>
Subject: Re: [PATCH 1/3] hvc_dcc: Fix bad code generation by marking assembly volatile
In-Reply-To: <20110102090019.GC32469@atrey.karlin.mff.cuni.cz> (Pavel Machek's
	message of "Sun, 2 Jan 2011 10:00:19 +0100")
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
	<1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
	<1292875718-7980-2-git-send-email-sboyd@codeaurora.org>
	<alpine.LFD.2.00.1012201638150.10437@xanadu.home>
	<20110102090019.GC32469@atrey.karlin.mff.cuni.cz>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Sun, 02 Jan 2011 10:49:32 -0800
Message-ID: <8yazkrjkuo3.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02 2011, Pavel Machek wrote:

>> > diff --git a/drivers/char/hvc_dcc.c b/drivers/char/hvc_dcc.c
>> > index 6470f63..155ec10 100644
>> > --- a/drivers/char/hvc_dcc.c
>> > +++ b/drivers/char/hvc_dcc.c
>> > @@ -33,8 +33,7 @@
>> >  static inline u32 __dcc_getstatus(void)
>> >  {
>> >  	u32 __ret;
>> > -
>> > -	asm("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
>> > +	asm volatile("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
>> >  		: "=r" (__ret) : : "cc");
>> >  
>> >  	return __ret;
>
> Is volatile needed here? If __dcc_getstatus() return value is
> discarded, we want assembly discarded, right?

That's not really the issue being fixed.  Without the volatile, the
compiler is free to cache and reuse a previously loaded status value.
It is important that the status be read each time.

I don't think there is a way of indicating that assembly needs to happen
for each use, but that it is OK to discard if the value isn't used.
'volatile' is a bit overloaded.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

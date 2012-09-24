Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab2IXSFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:05:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45637 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab2IXSFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:05:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6845"; a="240485213"
Message-ID: <5060A0C8.5040501@codeaurora.org>
Date: Mon, 24 Sep 2012 11:04:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Clear breakpoints before enabling
 monitor mode
References: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org> <20120920173556.GQ4654@mudshark.cambridge.arm.com> <20120924171934.GE5522@mudshark.cambridge.arm.com>
In-Reply-To: <20120924171934.GE5522@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/12 10:19, Will Deacon wrote:
> On Thu, Sep 20, 2012 at 06:35:56PM +0100, Will Deacon wrote:
>> On Thu, Sep 20, 2012 at 05:57:40PM +0100, Stephen Boyd wrote:
>>> +/* Determine if halting mode is enabled */
>>> +static int halting_mode_enabled(void)
>>> +{
>>> +	u32 dscr;
>>> +
>>> +	ARM_DBG_READ(c1, 0, dscr);
>>> +
>>> +	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN,
>>> +		"halting debug mode enabled. Unable to access hardware resources.\n")) {
>>> +		return -EPERM;
>>> +	}
>>> +	return 0;
>>> +}
>> ...it looks like debug arch 7.1 defines this bit as UNKNOWN when the OS lock
>> is clear, so we probably shouldn't be reading it at all. I'll pour myself a
>> stiff drink and start reading the debug arch docs to work out what on Earth
>> we should do.
>>
>> Stay tuned.
> Ok, I've pushed a bunch of patches to my hw-breakpoint branch (head commit
> 55cb726797c7). I'll post them to the list after the merge window, but please
> do take them for a spin if you get a chance.
>

Sure, I'll try them later today. I would say just send them out so
people can add tested and reviewed tags. Otherwise we should all start
planning week long vacations every 7 to 8 weeks to coincide with the
merge window.

Also, it would be nice if we could fix this in 3.7 or even 3.6. Booting
on an MSM8660 is very fragile right now and this patch fixes it for me.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


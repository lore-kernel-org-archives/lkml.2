Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0G0Rc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:32:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36781 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0G0Rcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:32:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6056"; a="48952832"
Message-ID: <4C4F1846.3090103@codeaurora.org>
Date: Tue, 27 Jul 2010 10:32:54 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Israel Schlesinger <israels@codeaurora.org>, linux-kernel@vger.kernel.org,
        apw@canonical.com, akpm@linux-foundation.org, joe@perches.com
Subject: Re: [PATCH] checkpatch: Add warnings for use of mdelay()
References: <4C4F132F.6020401@codeaurora.org> <20100727113133.1605c9fe@bike.lwn.net>
In-Reply-To: <20100727113133.1605c9fe@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 10:31 AM, Jonathan Corbet wrote:
> On Tue, 27 Jul 2010 10:11:11 -0700
> Israel Schlesinger <israels@codeaurora.org> wrote:
> 
>> mdelay is a busy-wait loop which is wasteful. If at all possible,
>> callers should use msleep instead of mdelay.
>>
>> The only time mdelay is really appropriate is in atomic context,
>> however, delays of 1ms+ in atomic context are rather expensive, so
>> a warning for this case is probably appropriate as well to encourage
>> people to move such expensive delays outside of atomic context
> 
> Once upon a time, msleep(1) would sleep for 20ms, while mdelay(1) gave
> a 1ms delay.  My patch to fix msleep() at that time didn't get in due
> to concerns about the cost of using hrtimers.  Perhaps msleep() has
> gotten better, but, if not, actually getting a 1ms delay remains a
> valid reason for using mdelay() instead IMO.  It made a difference of a
> few seconds at open time for a driver I was doing at the time.
> 
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Check out the recently added usleep in -tip, and the checkpatch patch
pending in my queue that fixes that case (I'll send in a few hours ;) )

-pat

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

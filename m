Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab0HUEGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 00:06:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50179 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0HUEGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 00:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KPeV+b1/jaR3XjxNS6luuaAUW6F2APe2jSqZpAsujt/702A1FxJYiZ9iOqKJZj05AD
         8CttLAyyCACyd+Eet4MrHtsoIKW3gmo485QrL1raDEhoJjA8xTWQzQsl2tZRBp6exRVc
         kJfRxlGzIWIjXjcSf2IO16VZKfeQmqxhBTF4c=
MIME-Version: 1.0
In-Reply-To: <4C6F4BBB.5040207@zytor.com>
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com>
	<4C6F4BBB.5040207@zytor.com>
Date: Sat, 21 Aug 2010 00:06:32 -0400
Message-ID: <AANLkTi=sKH95tLee+H03ah=8dF6LV9hpw+1esGSZuHRS@mail.gmail.com>
Subject: Re: Linux 2.6.35.3
From: Mark Stanovich <mrktimber@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 11:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/20/2010 08:40 PM, Mark Stanovich wrote:
>> After updating to the 2.6.35.3 stable release, my machine was rebooting
>> automatically during the first few seconds of boot.
>>
>> I bisected to the first bad commit of
>>
>> commit 568132624386f53e87575195d868db
>> 9afb2e9316
>> Author: H. Peter Anvin <hpa@zytor.com <mailto:hpa@zytor.com>>
>> Date:   Tue Jul 27 17:01:49 2010 -0700
>>
>>     x86: Add memory modify constraints to xchg() and cmpxchg()
>>
>>     commit 113fc5a6e8c2288619ff7e8187a6f556b7e0d372 upstream.
>>
>>     xchg() and cmpxchg() modify their memory operands, not merely read
>>     them.  For some versions of gcc the "memory" clobber has apparently
>>     dealt with the situation, but not for all.
>>
>> I noticed that the latest version pulled from Linus's git tree did not
>> have the problem.  After looking at the changes to
>> arch/x86/include/asm/cmpxchg_32.h, I cherry-picked two patches from
>> Linus's tree that seemed to make a difference, namely:
>>
>> 69309a05907546fb686b251d4ab041c26afe1e1d
>> 4532b305e8f0c238dd73048068ff8a6dd1380291
>>
>> Applying these patches solved the rebooting problem on 2.6.35.3
>>
>> I believe the same problem also happens for the latest stable version of
>> 2.6.34, but did not verify the fix worked for the 2.6.34 stable releases.
>>
>> I don't know if this is helpful, but I thought I would let you know in
>> case someone else is having the same problem.
>>
>> If you need any further information, just let me know.
>>
>
> Yes, as a matter of fact, we have been trying to root-cause this
> problem; please see:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=16612
>
> If you could try the one-liner in there and see if it solves your
> problem, it would be great.

The patch for __set_64bit on top of 2.6.35.3 solves the rebooting problem!

>
>        -hpa
>
> P.S. What version of gcc do you use?

gcc (Gentoo 4.4.3-r2 p1.2) 4.4.3

Thanks,
Mark

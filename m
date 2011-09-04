Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1IDAWD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 20:22:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:58437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1IDAV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 20:21:59 -0400
Message-ID: <4E62C488.6040209@infradead.org>
Date: Sat, 03 Sep 2011 21:21:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Joe Perches <joe@perches.com>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH 06/14] [media] cx18: Use current logging styles
References: <cover.1313966088.git.joe@perches.com> <29abc343c4fce5d019ce56f5a3882aedaeb092bc.1313966089.git.joe@perches.com> <1314182047.2253.3.camel@palomino.walls.org> <1314222175.15882.8.camel@Joe-Laptop> <1314451740.2244.7.camel@palomino.walls.org> <1314463352.6852.5.camel@Joe-Laptop> <40a27a5f-f4ec-4304-88a1-a254c7bc6c68@email.android.com>
In-Reply-To: <40a27a5f-f4ec-4304-88a1-a254c7bc6c68@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-08-2011 14:23, Andy Walls escreveu:
> Joe Perches <joe@perches.com> wrote:
> 
>> On Sat, 2011-08-27 at 09:28 -0400, Andy Walls wrote:
>>> On Wed, 2011-08-24 at 14:42 -0700, Joe Perches wrote:
>>>> On Wed, 2011-08-24 at 06:34 -0400, Andy Walls wrote:
>>>>> On Sun, 2011-08-21 at 15:56 -0700, Joe Perches wrote:
>>>>>> Add pr_fmt.
>>>>>> Convert printks to pr_<level>.
>>>>>> Convert printks without KERN_<level> to appropriate pr_<level>.
>>>>>> Removed embedded prefixes when pr_fmt was added.
>>>>>> Use ##__VA_ARGS__ for variadic macros.
>>>>>> Coalesce format strings.
>>>>> 1. It is important to preserve the per-card prefixes emitted by
>> the
>>>>> driver: cx18-0, cx18-1, cx18-2, etc.  With a quick skim, I think
>> your
>>>>> change preserves the format of all output messages (except
>> removing
>>>>> periods).  Can you confirm this?
>>>> Here's the output diff of
>>>> strings built-in.o | grep "^<.>" | sort
>>>> new and old
>> []
>>> Yuck.
>>>>> 2. PLease don't add a pr_fmt() #define to exevry file.  Just put
>> one
>>>>> where all the other CX18_*() macros are defined.  Every file
>> picks those
>>>>> up.
>>>> It's not the first #include of every file.
>>>> printk.h has a default #define pr_fmt(fmt) fmt
>>> Well then don't use "pr_fmt(fmt)" in cx18, if it overloads a define
>>> somewhere else in the kernel and has a dependency on its order
>> relative
>>> to #include statements.  That sort of thing just ups maintenance
>> hours
>>> later.  That's not a good trade off for subjectively better log
>>> messages.
>>> Won't redifining the 'pr_fmt(fmt)' generate preprocessor warnings
>>> anyway?
>>
>> No.
>>
>> Andy, I fully understand how this stuff works.
>> You apparently don't (yet).
>>
>> Look at include/linux/printk.h
>>
>> #ifndef pr_fmt
>> #define pr_fmt(fmt) fmt
>> #endif
>>
>> A default empty define is used when one
>> is not specified before printk.h is
>> included.  kernel.h includes printk.h
>>
>> v4l2_<level> uses the "name" of the video
>> device in its output.  That name may not
>> be the same name as the module.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hi Joe,
> 
> I don't need to fully understand it.
> 
> This is a happy to glad change with no functional nor performance benefit.  It adds unneeded lines of code to the driver and mangles some of the log messages.
> 
> I see no benefit from my perspective.

Hi Andy and Jean-Francois,

>From my perspective, the advantage of using the standard macros for
errors are:

1) Consistency. Except for patches 06 and 14, the other patches were
acked by the maintainers or by me, for the drivers that I maintain
or whose maintainer didn't nack. Also, the same sort of macros are
being used on other places at the Kernel;

2) One of the proposed themes for discussion at the KS/2011 is how to
improve the error reporting. While printk works, there are better
ways of doing it than just printing the error at the console. I'm
working on something like that with regards to hardware errors,
reported via MCE and EDAC subsystems. The idea there is to convert
the printk reports into structured trace events, making easier for
userspace to deal with the errors.

Making all places to use the same macros for it using a similar format
seems to be the first step for replacing the current way for a better
one.

Regards,
Mauro

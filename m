Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab1H0RXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 13:23:42 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42876 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab1H0RXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 13:23:40 -0400
References: <cover.1313966088.git.joe@perches.com> <29abc343c4fce5d019ce56f5a3882aedaeb092bc.1313966089.git.joe@perches.com> <1314182047.2253.3.camel@palomino.walls.org> <1314222175.15882.8.camel@Joe-Laptop> <1314451740.2244.7.camel@palomino.walls.org> <1314463352.6852.5.camel@Joe-Laptop>
User-Agent: K-9 Mail for Android
In-Reply-To: <1314463352.6852.5.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 06/14] [media] cx18: Use current logging styles
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 27 Aug 2011 13:23:14 -0400
To: Joe Perches <joe@perches.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <40a27a5f-f4ec-4304-88a1-a254c7bc6c68@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-08-26_06:2011-08-27,2011-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1108270081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

>On Sat, 2011-08-27 at 09:28 -0400, Andy Walls wrote:
>> On Wed, 2011-08-24 at 14:42 -0700, Joe Perches wrote:
>> > On Wed, 2011-08-24 at 06:34 -0400, Andy Walls wrote:
>> > > On Sun, 2011-08-21 at 15:56 -0700, Joe Perches wrote:
>> > > > Add pr_fmt.
>> > > > Convert printks to pr_<level>.
>> > > > Convert printks without KERN_<level> to appropriate pr_<level>.
>> > > > Removed embedded prefixes when pr_fmt was added.
>> > > > Use ##__VA_ARGS__ for variadic macros.
>> > > > Coalesce format strings.
>> > > 1. It is important to preserve the per-card prefixes emitted by
>the
>> > > driver: cx18-0, cx18-1, cx18-2, etc.  With a quick skim, I think
>your
>> > > change preserves the format of all output messages (except
>removing
>> > > periods).  Can you confirm this?
>> > Here's the output diff of
>> > strings built-in.o | grep "^<.>" | sort
>> > new and old
>[]
>> Yuck.
>> > > 2. PLease don't add a pr_fmt() #define to exevry file.  Just put
>one
>> > > where all the other CX18_*() macros are defined.  Every file
>picks those
>> > > up.
>> > It's not the first #include of every file.
>> > printk.h has a default #define pr_fmt(fmt) fmt
>> Well then don't use "pr_fmt(fmt)" in cx18, if it overloads a define
>> somewhere else in the kernel and has a dependency on its order
>relative
>> to #include statements.  That sort of thing just ups maintenance
>hours
>> later.  That's not a good trade off for subjectively better log
>> messages.
>> Won't redifining the 'pr_fmt(fmt)' generate preprocessor warnings
>> anyway?
>
>No.
>
>Andy, I fully understand how this stuff works.
>You apparently don't (yet).
>
>Look at include/linux/printk.h
>
>#ifndef pr_fmt
>#define pr_fmt(fmt) fmt
>#endif
>
>A default empty define is used when one
>is not specified before printk.h is
>included.  kernel.h includes printk.h
>
>v4l2_<level> uses the "name" of the video
>device in its output.  That name may not
>be the same name as the module.
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Joe,

I don't need to fully understand it.

This is a happy to glad change with no functional nor performance benefit.  It adds unneeded lines of code to the driver and mangles some of the log messages.

I see no benefit from my perspective.

Regards,
Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab2HZGrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 02:47:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57127 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2HZGrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 02:47:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120826090603.6b833e54@pixies.home.jungo.com>
References: <1345904767-23011-1-git-send-email-shijie8@gmail.com>
	<20120825120231.73577d6a@halley>
	<CAMiH66HyfNEzEHGyZUcLJ_01PNVHqA44fjAqXsyM2c-HHms8hQ@mail.gmail.com>
	<20120826090603.6b833e54@pixies.home.jungo.com>
Date: Sun, 26 Aug 2012 02:47:39 -0400
Message-ID: <CAMiH66GVNad4dzbA9M66BGxGGb-JxQz8NJjBVWHcqp6FRpNbAQ@mail.gmail.com>
Subject: Re: [PATCH v2] mtd: cmdlinepart: fix the wrong partitions number when
 truncating occurs
From: Huang Shijie <shijie8@gmail.com>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 2:06 AM, Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
> Hi,
>
> On Sat, 25 Aug 2012 05:26:51 -0400 Huang Shijie <shijie8@gmail.com> wrote:
>> On Sat, Aug 25, 2012 at 5:02 AM, Shmulik Ladkani
>> <shmulik.ladkani@gmail.com> wrote:
>> > Your analysis seems right, but let me offer an alternative approach.
>> >
>> > I would simply:
>> >
>> > -                                       part->num_parts = i;
>> your code does not wors in such kernel command line(also with the 1GB
>> nand chip):
>> #gpmi-nand:100m(root),100m(kernel),1g(rootfs),1g(user),-(rest)
>>
>
> Can you please detail what do you mean by "not work"?
sorry. :)

My meaning was the result is unreadable. It looks too strange. That's
why i use the 'break'
to shortcut the loop.

>
> To my understanding, in this example, according to my suggestion, the
> resulting partitions would be:
>
> root    100m@0
> kernel  100m@100m
> rootfs  800m@200m (truncated)
> user    0@1g (truncated)
> rest    0@1g
>

yes, the result is like this.

> Reasonable IMO, given the fact that the mtd device size is smaller than

> the specified parts.
>
> I saw you submitted a patch which sorts the cmdline parts; I don't
> understand why this is necessary.
> Also, sorting might not be desirable, as the user specified the unsorted
> partitions might have _wanted_ them to appear in that order.
>
> Now lets focus on your original suggestion and its consequences:
>
> - Orignal code STOPPED parsing at the 1st truncated partition,
>   this partition WAS NOT returned to the caller
> - Your patch STOPS AFTER parsing the 1st truncated partition,
>   this partiton IS returned to the caller (but partitions specified
>   later are no longer parsed)
> - My suggestion CONTINUES parsing all partitions.
>   So later partitions (specified with the 'size' but *without* 'offset')
>   will be truncated AND presented to the caller.
>   AND, if later partitions are specified using the 'size@offset'
>   explicit format, they are parsed normally.
>

Could Artem or David point us a direction about this?
[1]  Should the unsorted partitions be supported?
[2] And what should we do when we meet a 1GB nand, and the cmdline is
      gpmi-nand:100m(root),100m(kernel),1g(rootfs),1g(user),-(rest)

thanks a lot
Huang Shijie

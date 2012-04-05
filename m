Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2DEIgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:36:06 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49827 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2DEIgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:36:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120405080820.GB17658@merkur.ravnborg.org>
References: <1333569554.864.3.camel@mop> <1333583480.23520.37.camel@joe2Laptop>
 <20120405003321.GB27595@kroah.com> <1333586419.23520.52.camel@joe2Laptop>
 <CAPXgP11qdyccftPPA9LSRKVb-Xnf8BzP+deUmTzHnuVxoTQKog@mail.gmail.com> <20120405080820.GB17658@merkur.ravnborg.org>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 5 Apr 2012 10:35:42 +0200
Message-ID: <CAPXgP13+UjRsG_LBMd_KbqS=1p_7XA0TaPeXnWQUSdq1tYvW_Q@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Joe Perches <joe@perches.com>, Greg Kroah-Hartmann <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 10:08, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >
>> > How are arbitrary key/value pairs attached
>> > in a printk?
>>
>> There are 120 lines in the changelog, and a 100 lines large comment
>> block in the source code, and another 50 lines spread over the code,
>> and the hexdump examples in it, and all that? Even without looking at
>> a single line of code, it should be explained from different
>> viewpoints more than once.
>
> color me blind - but I could not find any example of how I specify
> key/value pairs when I use printk().
>
> I could find lots of internal information - that parts looks to
> be extensively documented - good.
>
> But how I as a user specify this I failed to find.
> Today I do:
>
>    printk(KERN_ERR "foobar is bad");
>
> But how is that extended to include the key/value pairs?

The use of structured data is mainly focused on subsystem specific
users. Like the block layer or the network stack could invent a bunch
of well-defined set of properties, and wrap the emission of these up
in some common subsystem logging functions for their drivers to use.
They would reflect common log events, meaningful in the context of a
specific subsystem.

Think of it more like the model how we handle properties in uevents,
it's a similar approach.

This is not so much intended to convert the (almost random) language
in slightly better (random) key/value pairs. Userpace, which is the
only reason to add that stuff in the first place, will need to know
how to make sense out of the passed values, so in the future, we will
need some kind of coordination per subsystem here.

For the current simple example in the patch, look where DEVICE= and
SUBSYSTEM= are passed through dev_printk() -> vprintk_emit() ->
log_store(), and then read through /dev/kmsg.

The output looks like something like this:
  http://people.freedesktop.org/~kay/dev-kmsg.txt

Kay

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2EKKfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:35:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37603 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2EKKf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:35:29 -0400
MIME-Version: 1.0
In-Reply-To: <1336617045.25027.2.camel@mop>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
 <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
 <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 12:35:07 +0200
Message-ID: <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 4:30 AM, Kay Sievers <kay@vrfy.org> wrote:
> On Wed, 2012-05-09 at 16:06 -0700, Greg Kroah-Hartmann wrote:
>> On Wed, May 09, 2012 at 04:02:40PM -0700, Yinghai Lu wrote:
>> > On Wed, May 9, 2012 at 7:37 AM, Kay Sievers <kay@vrfy.org> wrote:
>> > >
>> > >> Changing printk semantics and trying to stabilize
>> > >> printk message content are bad ideas though.
>> > >
>> > > Again, nobody talks about content of here.
>> >
>> > printk_time=1 does not work anymore with this patch on serial console.
>>
>> Known issue, I think Kay is working on the solution for this right
>> now...
>
> Sure, and this seems to work for me.
>
> Thanks,
> Kay
>
>
> From: Kay Sievers <kay@vrfy.org>
> Subject: printk() - restore timestamp printing at console output
>
> The output of the timestamps got lost with the conversion of the
> kmsg buffer to records; restore the old behavior.
>
> Document, that CONFIG_PRINTK_TIME now only controls the output of
> the timestamps in the syslog() system call and on the console, and
> not the recording of the timestamps.
>
> Signed-off-by: Kay Sievers <kay@vrfy.org>
> ---

This has a small issue with the way timing is printed compared to how
it worked previously.

Consider the following case:

    printk("\n foo \n bar \n zoot")

Previously, you would see timing on each line of the print, but now
you see it only on the first.

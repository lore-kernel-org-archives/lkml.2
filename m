Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab0EZULU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:11:20 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17700 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0EZULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:11:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=Ey6Sh6LszFskzkzAj1P/+3zNaYDX6xo+jS5+6oHUp32G+2JWi+OZKrT6EibYvxTEC
	xjy1BAwxMw8jR9CiW30wg==
MIME-Version: 1.0
In-Reply-To: <20100526193255.GC9874@ghostprotocols.net>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
	<AANLkTil5WtBnMQt1odjEgmWHOuuKxb4AIyuBLAqOiUSg@mail.gmail.com>
	<20100526005531.GA9874@ghostprotocols.net>
	<AANLkTim-xv9mNEwGCueV47AoKh6AXbrdbTdCEwZHaEHJ@mail.gmail.com>
	<20100526182351.GB9874@ghostprotocols.net>
	<AANLkTimOEUKYXzdMOiWE6gRxR7vJX36VscdLjRroqGLq@mail.gmail.com>
	<20100526193255.GC9874@ghostprotocols.net>
Date: Wed, 26 May 2010 22:11:14 +0200
Message-ID: <AANLkTinxVsp1qtfqjlwl-ngrcD9IBDg6GoBnAk07ABuo@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] perf annotate fix and report improvoment
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 9:32 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Wed, May 26, 2010 at 09:07:05PM +0200, Stephane Eranian escreveu:
>> Hi,
>>
>> +lkml et al.
>>
>> On Wed, May 26, 2010 at 8:23 PM, Arnaldo Carvalho de Melo
>> <acme@infradead.org> wrote:
>> > Em Wed, May 26, 2010 at 06:45:18PM +0200, Stephane Eranian escreveu:
>> >> Attached is the trace for
>> >> perf annotate -i ~/perf.data noploop
>> >>
>> >> I get no output at all (TUI is off). Copied over .debug tarball + perf.data.
>> >
>> > Looks like the bug I'm investigating now:
>> >
>> > build id event received for [kernel.kallsyms]: 54b1e7cc3cf52e0db255aab44ce7538eb62655b8
>> > build id event received for /tmp/noploop: 875ae61623e89f408b425ca0486a9ec99e3ac73e
>> > Looking at the vmlinux_path (5 entries long)
>> > No build_id in vmlinux, ignoring it
>> > No build_id in /boot/vmlinux, ignoring it
>> > No build_id in /boot/vmlinux-2.6.34-tip-default+, ignoring it
>> > build_id in /lib/modules/2.6.34-tip-default+/build/vmlinux is
>> > 3635a0e8dfc9a1afbd5627c2ba789e41d77d3cd1 while expected is
>> > 54b1e7cc3cf52e0db255aab44ce7538eb62655b8, ignoring it
>> > No build_id in /usr/lib/debug/lib/modules/2.6.34-tip-default+/vmlinux, ignoring it
>> >
>> > In my case it is not finding the vmlinux because I'm using RHEL6 Beta
>> > kernel without the respective kernel-debuginfo{-common} packages so it
>> > doesn't find the vmlinux, uses just /proc/kallsyms and that is not
>> > enough for annotation.
>> >
>> > In your case the problem is that we only cache the kallsyms file in the
>> > build-id cache ($HOME/.debug) and that is not enough for annotation, so
>> > I have to fix two things:
>> >
>> I can understand the issue with the kernel symbols.
>
> That has to be fixed and I've got some patches already for that, testing
> them now.
>
>> But in this example, I only really care about the symbols in the
>> noploop program (/tmp/noploop).
>>
>> Missing symbol support for the kernel should not cause perf to avoid
>> trying to resolve the symbols in other modules such as my user program
>> here.
>
> Right, my bad, I thought that the problem was about the kernel symbols.
>
> Then can you try replacing:
>
> perf annotate -i ~/perf.data noploop
>
> with:
>
> perf annotate -i ~/perf.data -d noploop
>
> And see if that helps?
>
Ok that works. But if I turned on TUI, then I cannot obtain
the same result. I am guessing it does not use the -d option.

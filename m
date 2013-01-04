Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3ADINk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:13:40 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:37203 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3ADINi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <y0mliceujz4.fsf@fche.csb>
References: <CACV3sb+69VQMM44vXx_-AdOZmbz18zZeVdmi1+YHEq7kZ_VmdA@mail.gmail.com>
	<y0mliceujz4.fsf@fche.csb>
Date: Fri, 4 Jan 2013 16:13:38 +0800
Message-ID: <CACV3sbKk3euv8N4SbBegJ=iYuUxfdynZ_1GNtfkwGzwGDcqATw@mail.gmail.com>
Subject: Re: [RFC] ktap: Another dynamic tracing tool for Linux
From: Jovi Zhang <bookjovi@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 1, 2013 at 2:58 AM, Frank Ch. Eigler <fche@redhat.com> wrote:
>
> bookjovi wrote:
>
>
>> [...]  This mail is RFC for discuss on a new dynamic tracing tool, I
>> name it ktap. (only experimental project now)
>
> Welcome to the problem domain!
Thanks very much, frank, I'm so luck to discussing this topic with you. :)
>
>
>> [...]
>> what ktap differentiates with Systemtap is:
>> [...]
>> 2). ktap have good portability, because it compile source file to
>> bytecode, like python and Java.
>
> (From this PoV, systemtap is just as portable as the kernel, as it
> generates the same sort of C code the kernel is built from.)
>
the portability for ktap what I mean here is binary portability, you
will not need to
compile arm and x86 binary in ktap, it's all bytecode.
but as you pointed, systemtap also have good portability in source
level, for more clear,
I will change the readme text a little bit about this portability.  thanks.

>> [...]
>> 5). ktap will be open source completely, with GPL license, it might be
>> merge into mainline in someday, that's very convince for tracing user.
>
> (systemtap has always been GPLv2, ever since its beginning in 2005.)

Yes, you are right, both is GPL licensed.
>
>
>> [...]
>> ktap use lua language syntax and bytecode as initial implementation,
>
> Interesting approach.  I recall we considered it way back when, but
> rejected it for a couple of reasons, including the at-the-time
> perceived unwelcomeness of a serious bytecode interpreter within the
> kernel.
>
ktap is more like Dtrace, without gcc compiling.
Obviously, the bytecode design is the biggest differences with systemtap.
systemtap really is a valueable tracing tool, but in many case we cannot use it.
many Linux box doesn't deverily with gcc, this is very common in
embedded device,
even there installed gcc, but it's hard(impossible) to get matched
kernel source.
embeded world have many hardware architectures, arm/x86/mips/ppc, when
those different
hardware board is combined into a cluster, you need to prepare several
systemtap kernel module
in development machine, then upload all kernel module to cluster. but
if you have a bytecode
mechanism, that's totaly not neccessary, just a source script file or
bytecode chunk file.
This is just one advantage of bytecode mechanism.

Of course we must need to afford some penalty on performance compare
with raw C design(systemtap),
but gaining better convenient, one directing of ktap is reducing
bytecode executing overhead to minimal.

On clear that, ktap is not a replacement to systemtap, it's supplementation.
>
>> it could support kprobe, uprobe, userspace probe, etc.
>
> Great.
>
>> I wish you can give me some technical architecture pre-review for
>> ktap, before ktap release 1.0.
>> Any comments is welcome, thanks very much.
>
> Have you made any source code available yet?
>
I will try to make ktap develop progress more faster, and make ktap
source code public available soon.

.jovi

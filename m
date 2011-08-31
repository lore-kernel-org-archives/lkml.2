Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1HaXQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 19:16:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40141 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1HaXQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 19:16:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=IrQrIW6q9DlItE1z2ie0FH+0u5KwfJTraFksayrQOA8yjAYGIYvoQBJbvOWD1CNL4
	2x/f9O9h+S/Dk47McaIZQ==
MIME-Version: 1.0
In-Reply-To: <1314770655.5738.512.camel@simey>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	<CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>
	<x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
	<4E5D5817.6040704@kernel.dk>
	<CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
	<4E5D64E8.7000102@kernel.dk>
	<20110830154157.d802d097.akpm@linux-foundation.org>
	<CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
	<20110830155438.bc31ab99.akpm@linux-foundation.org>
	<1314770655.5738.512.camel@simey>
Date: Wed, 31 Aug 2011 16:16:28 -0700
Message-ID: <CAAK6Zt1wHdm6tRW10zGS1eNQtE+29bv-8RxT99ZOMDNeRc0X_g@mail.gmail.com>
Subject: Re: Approaches to making io_submit not block
From: Daniel Ehrenberg <dehrenberg@google.com>
To: guy keren <choo@actcom.co.il>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 11:04 PM, guy keren <choo@actcom.co.il> wrote:
> On Tue, 2011-08-30 at 15:54 -0700, Andrew Morton wrote:
>> On Tue, 30 Aug 2011 15:45:35 -0700
>> Daniel Ehrenberg <dehrenberg@google.com> wrote:
>>
>> > >> Not quite sure, and after working on them and fixing thing up, I don't
>> > >> even think they are that complex or intrusive (which I think otherwise
>> > >> would've been the main objection). Andrew may know/remember.
>> > >
>> > > Boy, that was a long time ago. __I was always unhappy with the patches
>> > > because of the amount of additional code/complexity they added.
>> > >
>> > > Then the great syslets/threadlets design session happened and it was
>> > > expected that such a facility would make special async handling for AIO
>> > > unnecessary. __Then syslets/threadlets didn't happen.
>> >
>> > Do you think we could accomplish the goals with less additional
>> > code/complexity? It looks like the latest version of the patch set
>> > wasn't so invasive.
>> >
>> > If syslets/threadlets aren't happening, should these patches be
>> > reconsidered for inclusion in the kernel?
>>
>> I haven't seen any demand at all for the feature in many years.  That
>> doesn't mean that there _isn't_ any demand - perhaps everyone got
>> exhausted.
>
> you should consider the emerging enterprise-grade SSD devices - which
> can serve several tens of thousands of I/O requests per device actually
> controller). These devices could be better utilized by better
> interfaces. further more, in our company we had to resort to using
> windows for IOPS benchmarking (using iometer) against storage systems
> using these (and similar) devices, because it manages to generate higher
> IOPS then linux can (i don't remember the exact numbers, but we are
> talking about an order of several hundred thousands IOPS).
>
> It could be that we are currently an esoteric use-case - but the
> high-end performance market seems to be stepping in that direction.

I'm interested in SSD performance too. Could you tell me more about
your use case? Were you using a file system or a raw block device? The
patches we're discussing don't have any effect on a raw block device.
Do you have any particular ideas about a new interface? What does
Windows provide that Linux lacks that's relevant here?
>
>> If there is demand then that should be described and circulated, see
>> how much interest there is in resurrecting the effort.
>>
>> And, of course, the patches should be dragged out and looked at - it's
>> been a number of years now.
>>
>> Also, glibc has userspace for POSIX AIO.  A successful kernel-based
>> implementation would result in glibc migrating away from its current
>> implementation.  So we should work with the glibc developers on ensuring
>> that the migration can happen.
>
> glibc's userspace implementation doesn't scale to fast devices. It could
> make sense when working with slower disk devices - not when you're
> working with solid-state storage devices.
>
> --guy
>
>

Dan

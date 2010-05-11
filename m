Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0EKRcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:32:13 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:55083 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0EKRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Y/5mC6+rZc8E8VRz/8c2lDWExJYYIBQlqAoiw1XbUYt8q0sOU6fUo8rxF1qHNQEf7p
         g7O3NHmtlbz//laNvAmerYjVnmPfvHBfuiiW8D2FVWUu0OeCPRSqvawqis9lv8qvnfqi
         HT2LF73F1FiN90eQ0RVWd5yrKT5QRrxSBz5xg=
MIME-Version: 1.0
In-Reply-To: <20100511165228.GC7396@core.coreip.homeip.net>
References: <1273487642-2169-1-git-send-email-os@emlix.com> 
	<1273488154-2993-1-git-send-email-os@emlix.com> <20100510142225.4bf215ef.akpm@linux-foundation.org> 
	<20100511060547.GA9644@core.coreip.homeip.net> <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com> 
	<20100511062110.GB9644@core.coreip.homeip.net> <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com> 
	<20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com> 
	<20100511165228.GC7396@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 May 2010 13:31:48 -0400
Message-ID: <AANLkTimxBtepO6A63Tv7UPxJDgQovjBTvscKUSpVPH8p@mail.gmail.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 12:52, Dmitry Torokhov wrote:
> On Tue, May 11, 2010 at 09:42:03AM +0300, Pekka Enberg wrote:
>> On Tue, May 11, 2010 at 9:33 AM, Dmitry Torokhov wrote:
>> >> what guarantee exactly do you have for that statement ?
>> >
>> > The data is kmalloced, kmalloc aligns on cacheline boundary AFAIK which
>> > means that next kmalloc data chunk will not share "our" cacheline.
>>
>> No, there are no such guarantees. kmalloc() aligns on
>> ARCH_KMALLOC_MINALIGN or ARCH_SLAB_MINALIGN depending on which is
>> bigger but beyond that, there are no guarantees. You can, of course,
>> use kmem_cache_create() with SLAB_HWCACHE_ALIGN to align on cacheline
>> boundary.
>
> The architectures that we are trying to deal with here should be forcing
> kmalloc to the cache boundary already though - otherwise they would not
> be able to used kmalloced memory for DMA buffers at all. Or am I utterly
> lost here?

i dont want to restrict the driver so that it implicitly only works on
certain arches.  that kind of goes against the entire point of the
driver model.  the only thing this driver needs is a SPI bus, and
people can easily do that on most every arch.
-mike

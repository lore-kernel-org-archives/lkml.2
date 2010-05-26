Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0EZHgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:36:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56335 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0EZHgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yDi1gUk43GESJyoOQnFViogA2xcQUUc9GgxriNpsQaSdPScfBhZNCXF0weZvw40Ps4
         +yL+3hwkF6K5qmanADT5e6h7LxSL27o6e5N2lMNw2glHgg0SylEvglPScjHvZHQ+2xn6
         djcONAjxhujGfuoVv4y/6JltkCdPOIjZ9D7dk=
MIME-Version: 1.0
In-Reply-To: <20100526073334.GD26696@linux-sh.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 
	<20100525210755.GA8920@linux-sh.org> <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com> 
	<4BFC8617.9010501@codesourcery.com> <AANLkTilU133SjYfKGvUiQQ8v-CiecRYmKtH2tzAxL-3u@mail.gmail.com> 
	<AANLkTimWuqtLtnrgA8SHa-XoN8YdHJhQ6F2BngmmKSrl@mail.gmail.com> 
	<20100526073334.GD26696@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 26 May 2010 03:36:08 -0400
Message-ID: <AANLkTimnerGW-qsZNKINW5GmTdMCpT39RmhcWH5Br-iX@mail.gmail.com>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the 
	slab
To: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Jie Zhang <jie@codesourcery.com>, uclinux-dev@uclinux.org,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:33, Paul Mundt wrote:
> On Wed, May 26, 2010 at 03:23:02AM -0400, Mike Frysinger wrote:
>> On Wed, May 26, 2010 at 02:59, Geert Uytterhoeven wrote:
>> > From looking at <linux/flat.h>, it looks like the FLAT binary format
>> > doesn't contain any
>> > alignment information? So if I put __attribute__((aligned(4096))) in a
>> > file, there's still
>> > no guarantee it will actually be in memory at a 4Ki-aligned address?
>>
>> i believe that is correct.  FLAT behavior today provides alignment of
>> either sizeof(unsigned long) or ARCH_SLAB_MINALIGN.
>>
>> i imagine something like this would work today because everyone
>> defines it to a constant:
>> -#ifdef ARCH_SLAB_MINALIGN
>> +#if defined(ARCH_SLAB_MINALIGN) && ARCH_SLAB_MINALIGN != 0
>> but this would break if someone tried using gcc sizeof/alignof/etc...
>
> alignof is used by SLUB/SLOB to set the ARCH_SLAB_MINALIGN value if the
> architecture hasn't already specified one, so that wouldn't work.

sorry, the implied file here is the FLAT loader, not some other
header.  and the FLAT loader either uses the define directly in its
math, or uses the ALIGN() macro.  so alignof shouldnt matter.
-mike

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab1EBVo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:44:27 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:60793 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab1EBVoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D5jmfos4vfM7gLSwxzsnsUz1erqmJRppBBlthXEtVX0gx6UUSVr3NIRGXmLoQARhPm
         z+WumHlnLujTPCfgVXYivaHFnXsIcsuGOTfFPwW2byhvTIwQAqOTaFQrYC8L6MGELkTW
         xCqvXcgtjzVSEK4XMzmXfJF7VEOqyVp5/m9/8=
MIME-Version: 1.0
In-Reply-To: <1304366677.2833.170.camel@localhost>
References: <20110429185656.051229285@clark.kroah.org>
	<1304366677.2833.170.camel@localhost>
Date: Tue, 3 May 2011 09:44:25 +1200
Message-ID: <BANLkTi=7fq47qOrteHiyLD6ChheYXe567w@mail.gmail.com>
Subject: Re: [Stable-review] [36/55] [PARISC] slub: fix panic with DISCONTIGMEM
From: Michael Schmitz <schmitzmic@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: James Bottomley <James.Bottomley@suse.de>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Pekka Enberg <penberg@kernel.org>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

Commit 4aac0b4815ba592052758f4b468f253d383dc9d6 does in fact fix the
SLUB related panic on m68k, wiith DISCONTIGMEM and !NUMA configured.

m68k needs DISCONTIGMEM but does not need NUMA. David has explained
the rationale behind the patches in a post to linux-m68k. I've just
made his patch work properly on m68k, I haven't investigated any
further as to why exactly it happens to fix our issues.

Cheers,

  MIchael


On Tue, May 3, 2011 at 8:04 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Fri, 2011-04-29 at 11:55 -0700, Greg KH wrote:
>> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>>
>> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>>
>> commit 4a5fa3590f09999f6db41bc386bce40848fa9f63 upstream.
>>
>> Slub makes assumptions about page_to_nid() which are violated by
>> DISCONTIGMEM and !NUMA.  This violation results in a panic because
>> page_to_nid() can be non-zero for pages in the discontiguous ranges and
>> this leads to a null return by get_node().  The assertion by the
>> maintainer is that DISCONTIGMEM should only be allowed when NUMA is also
>> defined.  However, at least six architectures: alpha, ia64, m32r, m68k,
>> mips, parisc violate this.  The panic is a regression against slab, so
>> just mark slub broken in the problem configuration to prevent users
>> reporting these panics.
>
> This stable series also included the patches:
>
> commit 6a682f634ba9615d3498d1e20a23e9d4fcb39f16
> Author: David Rientjes <rientjes@google.com>
> Date:   Wed Apr 20 19:27:13 2011 -0700
>
>    set memory ranges in N_NORMAL_MEMORY when onlined
>
>    commit d9b41e0b54fd7e164daf1e9c539c1070398aa02e upstream.
>
> commit 8858587af25efc06d5cce42676786b3d7a9160f2
> Author: Michael Schmitz <schmitzmic@googlemail.com>
> Date:   Tue Apr 26 14:51:53 2011 +1200
>
>    m68k/mm: Set all online nodes in N_NORMAL_MEMORY
>
>    commit 4aac0b4815ba592052758f4b468f253d383dc9d6 upstream.
>
> which look like they're supposed to make slub work on these two
> architectures (parisc and m68k).  Do they?  If not, do they fix a
> different problem?
>
> Ben.
>
> --
> Ben Hutchings
> Once a job is fouled up, anything done to improve it makes it worse.
>

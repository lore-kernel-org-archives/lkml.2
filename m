Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab0E0UV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:21:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60082 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab0E0UV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ZNuMmFKBUdmQzGgWyIIJZoQ1MBK15+a3V98kKmBE3UzQ/MvDELj/WBs9hydyXqkl1F
         +1JwdL+4aKfnN0Bs0ndYS4DZ6495Xs9zGJecXm78+uKLyGvgLpwlbWBVd/02Fa+YD/Jv
         MoK+sSooMkDlKWXKQ8yW6llz9MN6PxgzrNySA=
MIME-Version: 1.0
In-Reply-To: <20100527195544.GA25935@redhat.com>
References: <1274431345-22366-1-git-send-email-vapier@gentoo.org> 
	<20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> 
	<20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> 
	<20100524151445.GA6393@redhat.com> <17134.1274778852@redhat.com> 
	<20100525102345.GA23574@redhat.com> <AANLkTilT3D8c86LYK2DxcNpM2F3D8iCbgY_sfUg8h58p@mail.gmail.com> 
	<20100526124006.GA28358@redhat.com> <20100527195544.GA25935@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 27 May 2010 16:21:04 -0400
Message-ID: <AANLkTik5mWPysArnlyZKdnjUxNzyde8myKCbTvxJIj8G@mail.gmail.com>
Subject: Re: [PATCH 0/2] blackfin: ptrace mm/sram_list fixes
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-sh@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 15:55, Oleg Nesterov wrote:
> On 05/26, Oleg Nesterov wrote:
>> On 05/25, Mike Frysinger wrote:
>> > we probably should add proper locking to this
>> > structure though.
>>
>> Agreed. I'll try to make the trivial patch tomorrow. I think we
>> can just use mm->mmap_sem, is_user_addr_valid() needs this lock
>> for find_vma() anyway.
>
> please see the patches.

awesome !  wasnt expecting someone to do the work for us :).

> UNTESTED! the second one certainly needs the review from someone
> who knows what this code does ;)

np.  after i look them over, i'll suck them into the Blackfin tree and
let them settle for a release for our test suites to shake out
problems.

> BTW. Obviously sys_sram_alloc() can create multiple sram_list_struct
> nodes with the same ->addr (with or without this patch), I hope this
> is fine.

how so ?  Blackfin is a nommu arch, so there should be no aliasing
issues.  each of the individual L1 sub-allocators manage a different
address range, and none of those should return an address that is
already in use.  it could happen that the code calling these funcs
calls a free func directly instead of going through the lsl free, but
that's a bug in the usage, not this code.
-mike

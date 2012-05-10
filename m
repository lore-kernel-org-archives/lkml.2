Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2EJOVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:21:18 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:42808 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751197Ab2EJOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:21:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yV5i988VM1l.Oq3TYj4iZAH.wPSgbDhPaoGz8rb.pk6x9P8
 tRq.62XSjTZV46rj6ym6SumKrWQgq4WX5IRcOlLTBwDgEIJfOOM86z2Zh1hM
 bUpMczRyFNKXQfJ3NAp_e1eShjJMdqiVI0BTmbzTEZwaUnOXuzbusm4U7N1f
 KssMqxmT25eYpudyapyeK3DahICVCJvN6Oyp4S11FfelbD.wAvM4nrkAAsGC
 5MVnfglbHP1fcWwwIz1acUViCm6VLXKeHTLAC88redH3TcKY3jZLMdRbrnwI
 9Zvz.dzNBWiKLaL.WY.lAtWHtKSNfoJWn0iFloVYVMTiELIZyDNunvZ0.JCh
 zrfiWmgbQEetVDFEtkh_7fdXnoh6A7s4ODz2ArK9w26Wv8VHeBOVXGGpUCJu
 3
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 10 May 2012 09:21:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG at mm/slub.c:374
In-Reply-To: <CAFLxGvymF0yo3k_j6EON-nk9=mQDaL72mnBxxJOv2awiWgjeYQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205100920250.18664@router.home>
References: <CAFLxGvy0PHZHVL9rZx_0oFGobKftPBc0EN3VEyzNqvg13FUEfw@mail.gmail.com> <alpine.DEB.2.00.1205090907070.8171@router.home> <CAFLxGvymF0yo3k_j6EON-nk9=mQDaL72mnBxxJOv2awiWgjeYQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012, richard -rw- weinberger wrote:

> On Wed, May 9, 2012 at 4:14 PM, Christoph Lameter <cl@linux.com> wrote:
> > On Wed, 9 May 2012, richard -rw- weinberger wrote:
> >
> >> A few minutes ago I saw this BUG within one of my KVM machines.
> >> Config is attached.
> >
> > Interrupts on in __cmpxchg_double_slab called from __slab_alloc? Does KVM
> > do some tricks with interrupt flags? I do not see how that can be
> > otherwise since __slab_alloc disables interrupts on entry and reenables on
> > exit.
>
> Dunno.
> So far I've seen this BUG only once. :-\

Hmmm... allocate_slab() does some dangerous games with the "flag" variable
which determines if interrupts are to be reenabled and disabled but I
cannot see how it could have the effect that you are seeing.


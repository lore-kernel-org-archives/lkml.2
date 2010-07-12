Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0GLPPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:15:33 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:42444 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0GLPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:15:32 -0400
Date: Mon, 12 Jul 2010 10:11:50 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Heinz Diehl <htd@fancy-poultry.org>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
In-Reply-To: <20100710195621.GA13720@fancy-poultry.org>
Message-ID: <alpine.DEB.2.00.1007121010420.14328@router.home>
References: <20100709190706.938177313@quilx.com> <20100710195621.GA13720@fancy-poultry.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1120396131-1278947511=:14328"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1120396131-1278947511=:14328
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 10 Jul 2010, Heinz Diehl wrote:

> On 10.07.2010, Christoph Lameter wrote:
>
> > The following patchset cleans some pieces up and then equips SLUB with
> > per cpu queues that work similar to SLABs queues. With that approach
> > SLUB wins significantly in hackbench and improves also on tcp_rr.
>
> The patchset applies cleanly, however compilation fails with
>
> [....]
> mm/slub.c: In function =E2=80=98alloc_kmem_cache_cpus=E2=80=99:
> mm/slub.c:2093: error: negative width in bit-field =E2=80=98<anonymous>=
=E2=80=99
> make[1]: *** [mm/slub.o] Error 1
> make: *** [mm] Error 2
> make: *** Waiting for unfinished jobs....
> [....]

You need a sufficient PERCPU_DYNAMIC_EARLY_SIZE to be configured. What
platform is this? Tejon: You suggested the BUILD_BUG_ON(). How can he
increase the early size?


---1463811839-1120396131-1278947511=:14328--

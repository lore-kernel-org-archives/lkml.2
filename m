Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894Ab2CUSUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:20:18 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:33684 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753440Ab2CUSUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:20:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 81.ujcsVM1k8tLd9IJTlChHyd_7zF.zwXZR015h8PrXPTKl
 6BVpiIPnFRyyx7E2vcMZ2ySJj1ezMMSJKMxq8Ik5_BPNfeBI9RdHUhnyizli
 l.cxSPdyIjwkAElfgwBanFxrZ2NVQC0EUuP7XME60Kz6LI.564q98Y6y5Dhg
 qpjU.JVQ9PqYyIuYBTmQs.SzFc16wJ99.35BZa.pKHqFsrjFzC7hSLenQb8a
 Mk_if5mWQZiHmjprO6mrtFmKSnzAyYw.CgAP_pl4Jk4tlx1Y5r3pNN.y9x5l
 ZJNBd4OnmnwW1FHOlHsJG08T0o.KRTUZZ0gTSajE7M1IJP8cJsGcDWjGv_Xu
 crzBQ5S3NQ3DtZk3SjRerMkg6heIJ1igmMZkj8Cqu44v74g9Qp8sIcDtNePw
 e
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Mar 2012 13:20:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Patch workqueue: create new slab cache instead of hacking
In-Reply-To: <1332353119.9433.2.camel@edumazet-glaptop>
Message-ID: <alpine.DEB.2.00.1203211319100.25567@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com> <20120320154619.GA5684@google.com> <4F6944D9.5090002@cn.fujitsu.com> <CAOS58YPydFUap4HjuRATxza6VZgyrXmQHVxR83G7GRJL50ZTRQ@mail.gmail.com>
 <alpine.DEB.2.00.1203210910450.20482@router.home> <1332341381.7893.17.camel@edumazet-glaptop> <alpine.DEB.2.00.1203210959500.21932@router.home> <1332345859.5330.8.camel@edumazet-glaptop> <alpine.DEB.2.00.1203211253520.21932@router.home>
 <1332353119.9433.2.camel@edumazet-glaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012, Eric Dumazet wrote:

> On Wed, 2012-03-21 at 12:54 -0500, Christoph Lameter wrote:
> > On Wed, 21 Mar 2012, Eric Dumazet wrote:
> >
> > > On Wed, 2012-03-21 at 10:03 -0500, Christoph Lameter wrote:
> > > > On Wed, 21 Mar 2012, Eric Dumazet wrote:
> > > >
> > > > > Creating a dedicated cache for few objects ? Thats a lot of overhead, at
> > > > > least for SLAB (no merges of caches)
> > > >
> > > > Its some overhead for SLAB (a lot is what? If you tune down the per cpu
> > > > caches it should be a couple of pages) but its none for SLUB.
> > >
> > > SLAB overhead per cache is O(CPUS * nr_node_ids)  (unless alien caches
> > > are disabled)
> >
> > nr_node_ids==2 in the standard case these days. Alien caches are minimal.
>
>
> Thats not true. Some machines use lots of nodes (fake nodes) for various
> reasons.

Which is not a typical use case.

> And they cant disable alien caches for performance reasons.

Ok then lets genericize the slub merge in some form so that it works for
all slab allocators.



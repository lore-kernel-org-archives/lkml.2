Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2CURyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:54:43 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:47020 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752152Ab2CURym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:54:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Svt6LZsVM1ltBQdKE9Ma6E_vYj0MfmGL7pmHL_KfN792QKX
 u4mQZaA784WCRodKr1LKM.DwMDb.BUEAZEh4dT.zD45sfe_ONyJCOSQL5hIH
 .cuA0z44N9NHhlp.4fV.AfetGbF8aFZpm4nmyzOy5cbn4ODe9tOH7HvyGzZR
 iJXcW89P5osb0OWBmTXFkcphrU5rzZdSYGf2xLHp6R0qhwGfxiqWQY6MFiO.
 _p_t4qXDnbgiux548uLx406eI6HUEaC7YuyANzkAJu4kAkvanB3VJdo7NP5B
 829Sm9sUDN2TsPKdiSeIw7vHcIerVU.IdYvrhZdr550yQV9lbFSKI.GSJ8wk
 OHh8BNYdAym2sSzaz7r.Av6zSsfLs3raRZGcvQCaFQ9SNQJ.SAVlFtSlTZsV
 rmcaa2HX7cd73SEKjpHfk8y0rRghoG5iRfoKm
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Mar 2012 12:54:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Patch workqueue: create new slab cache instead of hacking
In-Reply-To: <1332345859.5330.8.camel@edumazet-glaptop>
Message-ID: <alpine.DEB.2.00.1203211253520.21932@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com> <20120320154619.GA5684@google.com> <4F6944D9.5090002@cn.fujitsu.com> <CAOS58YPydFUap4HjuRATxza6VZgyrXmQHVxR83G7GRJL50ZTRQ@mail.gmail.com>
 <alpine.DEB.2.00.1203210910450.20482@router.home> <1332341381.7893.17.camel@edumazet-glaptop> <alpine.DEB.2.00.1203210959500.21932@router.home> <1332345859.5330.8.camel@edumazet-glaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012, Eric Dumazet wrote:

> On Wed, 2012-03-21 at 10:03 -0500, Christoph Lameter wrote:
> > On Wed, 21 Mar 2012, Eric Dumazet wrote:
> >
> > > Creating a dedicated cache for few objects ? Thats a lot of overhead, at
> > > least for SLAB (no merges of caches)
> >
> > Its some overhead for SLAB (a lot is what? If you tune down the per cpu
> > caches it should be a couple of pages) but its none for SLUB.
>
> SLAB overhead per cache is O(CPUS * nr_node_ids)  (unless alien caches
> are disabled)

nr_node_ids==2 in the standard case these days. Alien caches are minimal.

> For few in flight objects, its just better to use standard kmalloc-xxxx
> caches.

Its easier to use a custom slab cache. Avoids hackery like we have in
workqueue.c


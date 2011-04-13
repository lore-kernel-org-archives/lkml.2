Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab1DMNgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:36:31 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:41033 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754937Ab1DMNga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:36:30 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cqZ0ic8VM1lRAfBXbmXyuICPy2rMNkNWfvmV_7AqfbLh0Yx
 ScsD_AYsCV6FKJJTnF8eKIkgT7abFTQyONt5QjZa3T3zly0YpriYTKSfN4tC
 Uo.ddBM6j4rT63JXPq91YZs984lbOYi2i8epU9E9qzTBFUaNzkGEfn_P97id
 _TO1GXD0adn.Do7xoH.J5QI_42NcSD0C9Sh1UtdKnTeR4XuonJk2x3KN5GAc
 bXejF_OtVtVIgYOwod_ZfD.F3Fhwzf1vGtlorFJYYy5bMo.u5zPn_CiRuzft
 3tWoXRxypCZFKDFvk9PToU7van1oddhRIRbIO3eqwfefKoKRec6XggWD2sx6
 v1iqJZFMyBSTFISnyvdKeIb2p
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Apr 2011 08:36:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: Fix a typo in config name
In-Reply-To: <alpine.DEB.2.00.1104121913410.15979@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104130835360.16214@router.home>
References: <4DA3FDB2.9090100@cn.fujitsu.com> <alpine.DEB.2.00.1104121301430.14692@router.home> <alpine.DEB.2.00.1104121913410.15979@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, David Rientjes wrote:

> On Tue, 12 Apr 2011, Christoph Lameter wrote:
>
> > On Tue, 12 Apr 2011, Li Zefan wrote:
> >
> > > There's no config named SLAB_DEBUG, and it should be a typo
> > > of SLUB_DEBUG.
> > >
> > > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > ---
> > >
> > > not slub expert, don't know how this bug affects slub debugging.
> >
> > Affects the bootstrap code.
> >
>
> I don't see how, there should be no partial or full slabs for either
> kmem_cache or kmem_cache_node at this point in the boot sequence.  I think
> kmem_cache_bootstrap_fixup() should only need to add the cache to the list
> of slab caches and set the refcount accordingly.

Hmmm... That depends on the number of objects in a slab page. If that is
one then we may have an issue.


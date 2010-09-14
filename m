Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0INR7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:59:55 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:44018 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751581Ab0INR7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:59:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Bd.3auIVM1nc7zWzSV7dx4iM8dp_v1ohTfLEUNIscWxVPtM
 NXfJ1cIJeBsodkyn1kWb4QRP_9Uy_ku3KJndf91RdhybR5VQjHI8tXnC95qh
 5luvD.hjadhB7N6kjodH7AO.qS1rmahsVvcAJODR3Eh709ejgWly6qGB_9kb
 nIqyJh8DP4pKdAZHUWf8cRKWViUHf8J_06QYyuknjqGIyFSNelyIkynMpCB4
 T
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Sep 2010 12:59:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] SLUB: Fix merged slab cache names
In-Reply-To: <4C8FB58F.8010706@kernel.org>
Message-ID: <alpine.DEB.2.00.1009141253000.444@router.home>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141221310.31857@router.home> <4C8FB2AC.1030107@kernel.org> <alpine.DEB.2.00.1009141244330.444@router.home> <4C8FB58F.8010706@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Pekka Enberg wrote:

> > > Do you mean refcount == 2? You don't know during kmem cache release time
> > > if
> > > someone was merged to the cache or not.
> > > > Ok. Keeping the original name. Why dont we do strdup by default and
> > > > always
> > > > do a kfree(s->name) on close?
> > > >
> > > I tried that. It gets very nasty during bootstrap.
> > Add it only to kmem_cache_create() not to kmem_cache_open. That is not
> > used during bootstrap. The bootstrap caches do not matter since they are
> > never freed
> I tried that too. It doesn't work because we get merged to kmalloc caches and
> can't do kfree() on them.

For most of the kmalloc caches we are already doing a kasprintf. See the
last for loop in kmem_cache_init(). There are a couple of cases where we
are not doing it right now. kmalloc-96 kmalloc-192 and
kmem_cache_node.






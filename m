Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1KWVT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:19:56 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:56269 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1KWVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:19:54 -0500
Subject: Re: [PATCH V2] slub: avoid potential NULL dereference or corruption
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Kujau <lists@nerdbynature.de>, markus@trippelsdorf.de,
        David Rientjes <rientjes@google.com>
In-Reply-To: <alpine.DEB.2.00.1111230916220.16139@router.home>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.DEB.2.00.1111220855460.25785@router.home>
	 <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.LFD.2.02.1111231030370.14209@tux.localdomain>
	 <alpine.DEB.2.00.1111230916220.16139@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 23 Nov 2011 23:19:51 +0200
Message-ID: <1322083191.1428.125.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 09:17 -0600, Christoph Lameter wrote:
> On Wed, 23 Nov 2011, Pekka Enberg wrote:
> 
> > On Tue, 22 Nov 2011, Eric Dumazet wrote:
> > > show_slab_objects() can trigger NULL dereferences or memory corruption.
> > >
> > > Another cpu can change its c->page to NULL or c->node to NUMA_NO_NODE
> > > while we use them.
> > >
> > > Use ACCESS_ONCE(c->page) and ACCESS_ONCE(c->node) to make sure this
> > > cannot happen.
> > >
> > > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> >
> > Did someone test this patch? Does it fix any of the reported issues?
> 
> It does not fix any current issues but it is safe against potential
> compiler refetching of variables that we have already checked against
> bad values.
> 
> I thought I acked it already?

Yes, you did. I'm just trying to figure out which ones are going
straight to Linus and which ones can wait for v3.3.

			Pekka


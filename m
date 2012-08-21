Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab2HUPi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:38:56 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:13236 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071Ab2HUPiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:38:54 -0400
Date: Tue, 21 Aug 2012 15:38:52 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] mempolicy: fix refcount leak in
 mpol_set_shared_policy()
In-Reply-To: <20120821071532.GB1657@suse.de>
Message-ID: <0000013949d61abd-83aaf442-a4a1-4558-9045-ed91d77aae00-000000@email.amazonses.com>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de> <1345480594-27032-5-git-send-email-mgorman@suse.de> <00000139459223d7-93a9c53f-6724-4a4b-b675-cd25d8d53c71-000000@email.amazonses.com> <20120821071532.GB1657@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Mel Gorman wrote:

> On Mon, Aug 20, 2012 at 07:46:09PM +0000, Christoph Lameter wrote:
> > On Mon, 20 Aug 2012, Mel Gorman wrote:
> >
> > > @@ -2318,9 +2323,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
> > >  	while (next) {
> > >  		n = rb_entry(next, struct sp_node, nd);
> > >  		next = rb_next(&n->nd);
> > > -		rb_erase(&n->nd, &p->root);
> >
> > Looks like we need to keep the above line? sp_delete does not remove the
> > tree entry.
> >
> > > -		mpol_put(n->policy);
> > > -		kmem_cache_free(sn_cache, n);
> > > +		sp_delete(p, n);
>
> Yes it does, could you have accidentally mixed up sp_free (which does not
> remove the tree entry) and sp_delete (which does)? The altered code ends
> up looking like this;

Yup I got that mixed up.

Reviewed-by: Christoph Lameter <cl@linux.com>

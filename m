Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0LQSox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:44:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37309 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab0LQSov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:44:51 -0500
MIME-Version: 1.0
Message-ID: <7fbf2264-04be-4899-9c1f-5c2e0942b158@default>
Date: Fri, 17 Dec 2010 10:44:06 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: RE: [RFC] radix_tree_destroy?
References: <62b1cf2f-17ec-45c9-a980-308d9b75cdc5@default
 20101217032721.GD20847@linux-sh.org>
In-Reply-To: <20101217032721.GD20847@linux-sh.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +void radix_tree_destroy(struct radix_tree_root *root, void
> (*slot_free)(void *))
> > +{
> > +	if (root->rnode == NULL)
> > +		return;
> > +	if (root->height == 0)
> > +		slot_free(root->rnode);
> 
> Don't you want indirect_to_ptr(root->rnode) here? You probably also
> don't
> want the callback in the !radix_tree_is_indirect_ptr() case.
> 
> > +	else {
> > +		radix_tree_node_destroy(root->rnode, root->height,
> slot_free);
> > +		radix_tree_node_free(root->rnode);
> > +		root->height = 0;
> > +	}
> > +	root->rnode = NULL;
> > +}
> 
> The above will handle the nodes, but what about the root? It looks like
> you're at least going to leak tags on the root, so at the very least
> you'd still want a root_tag_clear_all() here.

Thanks for your help.  Will do both.  My use model doesn't require
tags or rcu, so my hacked version of radix_tree_destroy missed those
subtleties.

So my assumption was correct?  There is no way to efficiently
destroy an entire radix tree without adding this new routine?

Thanks,
Dan

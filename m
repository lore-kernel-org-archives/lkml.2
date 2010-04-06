Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0DFVTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:19:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab0DFVTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:19:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100406194843.GJ5288@laptop>
References: <20100406194843.GJ5288@laptop> <20100406193134.26429.78585.stgit@warthog.procyon.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, corbet@lwn.net,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree_tag_get() is not as safe as the docs make out
Date: Tue, 06 Apr 2010 22:18:58 +0100
Message-ID: <27834.1270588738@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> Nack, just drop the BUG_ON.

I can do that.

> I don't know what you mean by "untrustworthy answer".

I was thinking that the answer you get from radix_tree_tag_get() may be invalid
if the tag chain is being modified as you read it.  So if you do:

	rcu_read_lock()
	...
	x = radix_tree_tag_get(r, i, t);
	...
	y = radix_tree_tag_get(r, i, t);
	...
	rcu_read_unlock()

Then you can't guarantee that x == y, even though you were holding the RCU read
lock.

As you suggested, I'll try and come up with a comment modification to this
effect.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2EALUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 07:20:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35911 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2EALUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 07:20:42 -0400
Message-ID: <1335871228.13683.141.camel@twins>
Subject: Re: Generic rbtree search & insert cores
From: Peter Zijlstra <peterz@infradead.org>
To: daniel.santos@pobox.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 01 May 2012 13:20:28 +0200
In-Reply-To: <4F9E7365.2040907@att.net>
References: <4F9E7365.2040907@att.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 06:11 -0500, Daniel Santos wrote:
> 
> So as long as our struct rbtree_relationship is a compile-time
> constant, the generated code will look pretty much (if not exactly)
> like that of the example code in rbtree.h.  Please let me know what
> you think.  I've tested this in a userspace program, but haven't fully
> stress tested it in kernelspace yet. 

Right, this ought to work.

I'm not sure the root_offset thing is worth it though, passing in the
rb_root pointer isn't much of a hassle, in fact I'd expect to pass rb
related pointers to a function called rbtree_insert().

Also, using a macro to create the rbtree_relationship thing would make
it easier. Something like:

	RB_RELATION(struct mouse, node, name, name_cmp);

I'd think you'd also want to provide an insertion variant that does the
leftmost thing, that's used in several places, and you'd also need one
for the augmented rb-tree.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2JJJwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:52:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:39581 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab2JJJwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:52:17 -0400
Message-ID: <1349862694.7880.114.camel@twins>
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
From: Peter Zijlstra <peterz@infradead.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        mingo@redhat.com, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-numa@vger.kernel.org
Date: Wed, 10 Oct 2012 11:51:34 +0200
In-Reply-To: <507540F5.7040501@cn.fujitsu.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
		 <1349780256.7880.12.camel@twins>
		 <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>
		 <1349815676.7880.85.camel@twins>
		 <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
	 <1349860216.7880.105.camel@twins> <507540F5.7040501@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 17:33 +0800, Wen Congyang wrote:
> 
> Hmm, if per-cpu memory is preserved, and we can't offline and remove
> this memory. So we can't offline the node.
> 
> But, if the node is hot added, and per-cpu memory doesn't use the
> memory on this node. We can hotremove cpu/memory on this node, and then
> offline this node.
> 
> Before the cpu is hotadded, cpu's node is -1. We set cpu<->node mapping
> when it is hotadded. So the entire cpu<->node mapping was not invariant
> during hotplug.
> 
> So it is why I try to clear it when the cpu is hot-removed.
> 
> As we need the mapping to migrate a task to the cpu on the same node first,
> I think we can clear the mapping when the node is offlined.

Hmm maybe, but hardware that can hot-add is rare and nobody has it so
nobody cares ;-)

But by clearing cpu_to_node on every hotplug you change semantics for
all hardware and everybody gets to feel the pain.

I'm not saying you cannot change things, I'm only saying you should be
far more careful about it, not change it and wait for things to break.
Put in some effort to find things that might break and warn people --
sure, you'll always miss some, and that's ok.



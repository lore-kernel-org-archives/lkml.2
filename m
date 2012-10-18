Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2JRAw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:52:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35414 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2JRAwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:52:54 -0400
Date: Wed, 17 Oct 2012 17:52:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        mingo@redhat.com, miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <alpine.DEB.2.00.1210101351050.31237@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1210171749150.20813@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <1349780256.7880.12.camel@twins> <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com> <1349815676.7880.85.camel@twins> <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
 <1349860216.7880.105.camel@twins> <alpine.DEB.2.00.1210101324000.28583@chino.kir.corp.google.com> <20121010133709.7eaefcdb.akpm@linux-foundation.org> <alpine.DEB.2.00.1210101351050.31237@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, David Rientjes wrote:

> It fixes a BUG() that only affects users who are doing node hot-remove, 
> which is still radically under development, and nobody cares about except 
> those on the cc list, but it also introduces the NULL pointer dereference 
> that is attempting to be addressed in this patch.  The "fix" that causes 
> this NULL pointer is clearly not the direction we want to go, I think we 
> have agreement at node hot-remove to iterate all possible cpus are map all 
> offline cpus with cpu_to_node(cpu) == node to NUMA_NO_NODE instead in the 
> generic hotplug code.
> 
> Regardless, this shouldn't be touching the acpi code which
> cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch and 
> cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch do since 
> it makes the behavior inconsistent across interfaces and architectures.
> 

Ok, so it's been a week and these patches are still in -mm.  This is what 
I was afraid of: patches that both Peter and I nacked sitting in -mm and 
allow a NULL pointer dereference because no alternative patch exists yet 
to fix the issue correctly.

Tang and Wen, are you intending on addressing these problems (i.e. not 
touching the acpi code at all and rather clearing cpu-to-node mappings at 
node hot-remove) as we've discussed or do I need to do it myself?

Thanks.

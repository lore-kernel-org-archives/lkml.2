Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1E0X1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:27:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab1E0X1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=woNEFWWyTuiB8/5cquOA+gFzn74q+wuFrYhVX3XqbqyUucGHvlIlmVDGuRvIXq7mgJ
         BvkABo3b+5cnRslbmGGQ==
Date: Fri, 27 May 2011 16:27:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] cpusets: randomize node rotor used in
 cpuset_mem_spread_node()
In-Reply-To: <20110527231708.GB3214@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1105271623410.9445@chino.kir.corp.google.com>
References: <20110414065146.GA19685@tiehlicka.suse.cz> <20110414160145.0830.A69D9226@jp.fujitsu.com> <20110415161831.12F8.A69D9226@jp.fujitsu.com> <20110415082051.GB8828@tiehlicka.suse.cz> <20110526153319.b7e8c0b6.akpm@linux-foundation.org>
 <20110527124705.GB4067@tiehlicka.suse.cz> <alpine.DEB.2.00.1105271157350.2533@chino.kir.corp.google.com> <20110527231708.GB3214@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011, Michal Hocko wrote:

> > CONFIG_NODES_SHIFT is used for UMA machines that are using DISCONTIGMEM 
> > usually because they have very large holes; such machines don't need 
> > things like mempolicies but do need the data structures that abstract 
> > ranges of memory in the physical address space.  This build breakage 
> > probably isn't restricted to only alpha, you could probably see it with at 
> > least ia64 and mips as well.
> 
> Hmmm. I just find strange that some UMA arch uses functions like
> {first,next}_online_node.
> 

They shouldn't, but they do use NUMA data structures like pg_data_t for 
DISCONTIGMEM.  The MAX_NUMNODES > 1 optimization in nodemask.h is to 
prevent doing things like node_weight() on a nodemask when we know that 
only one bit will ever be set, otherwise we could make it conditional on 
CONFIG_NEED_MULTIPLE_NODES.

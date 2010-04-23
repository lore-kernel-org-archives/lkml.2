Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0DWIpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:45:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57385 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0DWIp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:45:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=o13ntP5zh2CMgyK4oYwqRZpB/dc0secTHwvUlLB6+KVWcrhDgCN4k2Au4DKthtYL1
	7NMfeD9R3RYf72Eo4b32g==
Date: Fri, 23 Apr 2010 01:45:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Lee Schermerhorn <lee.schermerhorn@hp.com>, Nick Piggin <npiggin@suse.de>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: fix bugs of mpol_rebind_nodemask()
In-Reply-To: <4BD0F797.6020704@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1004230141400.2190@chino.kir.corp.google.com>
References: <4BD05929.8040900@cn.fujitsu.com> <alpine.DEB.2.00.1004221415090.25350@chino.kir.corp.google.com> <4BD0F797.6020704@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Miao Xie wrote:

> Suppose the current mempolicy nodes is 0-2, we can remap it from 0-2 to 2,
> then we can remap it from 2 to 1, but we can't remap it from 2 to 0-2.
> 
> that is to say it can't be remaped to a large set of allowed nodes, and the task
> just can use the small set of nodes for ever, even the large set of nodes is allowed,
> I think it is unreasonable.
> 

That's been the behavior for at least three years so changing it from 
under the applications isn't acceptable, see 
Documentation/vm/numa_memory_policy.txt regarding mempolicy rebinds and 
the two flags that are defined that can be used to adjust the behavior.

The pol->v.nodes = nodes_empty(tmp) ? *nodes : tmp fix is welcome, 
however, as a standalone patch.

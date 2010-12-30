Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab0L3Snk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 13:43:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18786 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0L3Snj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 13:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=T0uvMmTr7XJwjAn7MO4uu4XgT2C8fB72n6GwHFoYFBxC+qzV6FG/RhcaYNeUb91hT8
         uQSJYRMjxwwJhwyrWhzg==
Date: Thu, 30 Dec 2010 10:43:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 15/16] x86: Unify node_to_cpumask_map handling between
 32 and 64bit
In-Reply-To: <20101230124800.GD18831@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1012301040420.12207@chino.kir.corp.google.com>
References: <1293536929-31683-1-git-send-email-tj@kernel.org> <1293536929-31683-16-git-send-email-tj@kernel.org> <alpine.DEB.2.00.1012281240000.8883@chino.kir.corp.google.com> <20101230124800.GD18831@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Tejun Heo wrote:

> Sigh, the new NUMA emulation thing is 64bit only. :-( I'll see if it
> can be applied to 32bit too.  BTW, how does this interact with the
> Shaohui's patchset.  Isn't that about NUMA emulation too?  Are these
> the same patches?
> 

There's nothing new about NUMA emulation on x86_64, it's existed for well 
over four years (we've been using it at Google since 2.6.18, see 
Documentation/x86/x86_64/fake-numa-for-cpusets).  Shaohui's patches are 
completely seperate and add hotplug emulation.  You _could_ boot with a 
very minimal amount of memory and then hotplug all the emulated nodes like 
numa=fake does, but you may find it difficult to parse the e820 and 
interleave the nodes appropriately over the set of physical nodes in 
userspace.

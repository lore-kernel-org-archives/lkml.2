Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1BVWJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:09:06 -0500
Received: from smtp-out.google.com ([74.125.121.67]:61350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1BVWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JphC0m8c9kebysWHDXZdYlP4ER/bDMQbQbo4sZRAJjsip8PxjJcjF96TwDGZ3pTJdm
         EocNDvug98R2/avKmfxA==
Date: Tue, 22 Feb 2011 14:08:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        lwoodman@redhat.com
Subject: Re: [PATCH 6/8] Add __GFP_OTHER_NODE flag
In-Reply-To: <4D642F03.5040800@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1102221402150.5929@chino.kir.corp.google.com>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-7-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1102221333100.5929@chino.kir.corp.google.com> <4D642F03.5040800@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Andi Kleen wrote:

> > This makes the accounting worse, NUMA_LOCAL is defined as "allocation from
> > local node," meaning it's local to the allocating cpu, not local to the
> > node being targeted.
> 
> Local to the process really (and I defined it originally ...)  That is what
> I'm implementing
> 
> I don't think "local to some random kernel daemon which changes mappings on
> behalf of others"
> makes any sense as semantics.
> 

You could make the same argument for anything using kmalloc_node() since 
preferred_zone may very well not be on the allocating cpu's node.  So you 
either define NUMA_LOCAL to account for when a cpu allocates memory local 
to itself (as it's name implies) or you define it to account for when 
memory comes from the preferred_zone's node as determined by the zonelist.  
It's not useful to change it from the former to the latter since it's 
already the definition of NUMA_HIT.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1EDUKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:10:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18415 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1EDUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=eChXYDUI3U06S31Fyf5GDhDQNLFcCyvz5KNHxH5XjIKz2XkmR2gYFEF9U3RXfo9KEN
         Gquz0Ik+ZJrNvIHa2mZA==
Date: Wed, 4 May 2011 13:10:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes
In-Reply-To: <4DC1B151.7010300@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1105041309001.24395@chino.kir.corp.google.com>
References: <1304533058-18228-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1105041213310.22426@chino.kir.corp.google.com> <4DC1B151.7010300@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Andi Kleen wrote:

> >  The vmalloc_node() calls ensure that the nid is actually set in
> > N_HIGH_MEMORY and fails otherwise (we don't fallback to using vmalloc()),
> > so it looks like the failures for alloc_pages_exact_node() and
> > vmalloc_node() would be different?  Why do we want to fallback for one and
> > not the other?
> 
> The right order would be to try everything (alloc_pages + vmalloc)
> to get it node local, before trying everything else. Right now that's
> not how it's done.
> 

Completely agreed, I think that's how it should be patched instead of only 
touching the alloc_pages() allocation; we care much more about local node 
than whether we're using vmalloc.

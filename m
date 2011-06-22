Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1FVGcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:32:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47880 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1FVGcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=QtqJEaxtUSOCCZ9PYdybEmDXcdXLQ27Uw5F538HRxndIOej0LC+OHzQMcP8WsG2aFm
         3Oa/2//YE+fOjTCbTaEw==
Date: Tue, 21 Jun 2011 23:32:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        dave@linux.vnet.ibm.com, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm: make the threshold of enabling THP
 configurable
In-Reply-To: <4E018060.3050607@redhat.com>
Message-ID: <alpine.DEB.2.00.1106212325400.14693@chino.kir.corp.google.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-2-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211817340.5205@chino.kir.corp.google.com> <4E015C36.2050005@redhat.com> <alpine.DEB.2.00.1106212024210.8712@chino.kir.corp.google.com>
 <4E018060.3050607@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Cong Wang wrote:

> > Either way, this patch isn't needed since it has no benefit over doing it
> > through an init script.
> 
> If you were right, CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not needed,
> you can do it through an init script.
> 

They are really two different things: config options like 
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS and CONFIG_SLUB_DEBUG_ON are shortcuts 
for command line options when you want the _default_ behavior to be 
specified.  They could easily be done on the command line just as they can 
be done in the config.  They typically have far reaching consequences 
depending on whether they are enabled or disabled and warrant the entry in 
the config file.

This patch, however, is not making the heuristic any easier to work with; 
in fact, if the default were ever changed or the value is changed on your 
kernel, then certain kernels will have THP enabled by default and others 
will not.  That's why I suggested an override command line option like 
transparent_hugepage=force to ignore any disabling heursitics either 
present or future.

> If you were right, the 512M limit is not needed neither, you have
> transparent_hugepage=never boot parameter and do the check of
> 512M later in an init script. (Actually, moving the 512M check to
> user-space is really more sane to me.)
> 

It's quite obvious that the default behavior intended by the author is 
that it is defaulted off for systems with less than 512M of memory.  
Obfuscating that probably isn't a very good idea, but I'm always in favor 
of command lines that allow users to override settings when they really do 
know better.

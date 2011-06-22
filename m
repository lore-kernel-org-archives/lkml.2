Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1FVD3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:29:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1FVD3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=rS+ZHF8DwFpqLmfgUWBtf02OZPt5+UirwPAi3vhnslgueK/6vO46SR/+O9+lgzNOv0
         dipSQyCpy7kpAjo/KEqg==
Date: Tue, 21 Jun 2011 20:29:33 -0700 (PDT)
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
In-Reply-To: <4E015C36.2050005@redhat.com>
Message-ID: <alpine.DEB.2.00.1106212024210.8712@chino.kir.corp.google.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-2-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211817340.5205@chino.kir.corp.google.com> <4E015C36.2050005@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Cong Wang wrote:

> > I like the printk that notifies users why THP was disabled because it
> > could potentially be a source of confusion (and fixing the existing typos
> > in hugepage_init() would also be good).  However, I disagree that we need
> > to have this as a config option: you either want the feature for your
> > systems or you don't.  Perhaps add a "transparent_hugepage=force" option
> > that will act as "always" but also force it to be enabled in all
> > scenarios, even without X86_FEATURE_PSE, that will override all the logic
> > that thinks it knows better?
> 
> I think that is overkill, because we can still enable THP via /sys
> for small systems.
> 

That was already possible before your patch, your patch is only 
introducing a configuration value that determines whether it is enabled by 
default or not.  I was proposing a very simple interface that would 
override all logic that could be used instead when you know for certain 
that you want THP enabled by default regardless of its logic.  That's 
extendable because it can bypass any additional code added later to 
determine when it should default on or off without adding additional 
config options.  I wouldn't support an additional command line option, but 
rather only an additional option for transparent_hugepage=.

Either way, this patch isn't needed since it has no benefit over doing it 
through an init script.

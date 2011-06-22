Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab1FVBXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 21:23:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab1FVBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 21:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tOI51TqrKuWAu4KKp3JnCcnqzgbdVPe6A7mG2Bm2Zy9bjv+dpdcGLjTnPOIke1zGUb
         v1PoeDPsgUdCZm73YTwA==
Date: Tue, 21 Jun 2011 18:23:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Amerigo Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        dave@linux.vnet.ibm.com, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm: make the threshold of enabling THP
 configurable
In-Reply-To: <1308643849-3325-2-git-send-email-amwang@redhat.com>
Message-ID: <alpine.DEB.2.00.1106211817340.5205@chino.kir.corp.google.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-2-git-send-email-amwang@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011, Amerigo Wang wrote:

> Don't hard-code 512M as the threshold in kernel, make it configruable,
> and set 512M by default.
> 
> And print info when THP is disabled automatically on small systems.
> 
> V2: Add more description in help messages, correct some typos,
> print the mini threshold too.
> 

I like the printk that notifies users why THP was disabled because it 
could potentially be a source of confusion (and fixing the existing typos 
in hugepage_init() would also be good).  However, I disagree that we need 
to have this as a config option: you either want the feature for your 
systems or you don't.  Perhaps add a "transparent_hugepage=force" option 
that will act as "always" but also force it to be enabled in all 
scenarios, even without X86_FEATURE_PSE, that will override all the logic 
that thinks it knows better?

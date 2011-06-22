Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1FVDYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:24:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab1FVDYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Gd5AMW+eDeJrpe7Wib28xAlFi5OlEXjUt0syGj9LND2BkmTRA743YM1ASkx02SWA/J
         Z0bADNd0NA0LEL9j4m6Q==
Date: Tue, 21 Jun 2011 20:24:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm: completely disable THP by
 transparent_hugepage=0
In-Reply-To: <4E015CB8.1010300@redhat.com>
Message-ID: <alpine.DEB.2.00.1106212010520.8712@chino.kir.corp.google.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211814250.5205@chino.kir.corp.google.com> <4E015CB8.1010300@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Cong Wang wrote:

> > > Introduce "transparent_hugepage=0" to totally disable THP.
> > > "transparent_hugepage=never" means setting THP to be partially
> > > disabled, we need a new way to totally disable it.
> > > 
> > 
> > Why can't you just compile it off so you never even compile
> > mm/huge_memory.c in the first place and save the space in the kernel image
> > as well?  Having the interface available to enable the feature at runtime
> > is worth the savings this patch provides, in my opinion.
> 
> https://lkml.org/lkml/2011/6/20/506
> 

If you're proposing a patch for a specific purpose, it's appropriate to 
include that in the changelog.

But now that I know what you're proposing this for, it's an easy NACK: 
transparent_hugepage=0 has no significant benefit over 
transparent_hugepage=never for kdump because the memory savings is 
negligible.

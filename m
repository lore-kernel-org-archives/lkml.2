Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1JZGMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:12:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1JZGMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:12:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=M4jSefkWmDMHvnzQcdh/WAY6AZd4mkZnUdF+dXBlFH8hDi1n8GcP3ObdaoGUg/Frv
	zHEqz7X1abjbizoYkutLQ==
Date: Tue, 25 Oct 2011 23:12:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Colin Cross <ccross@android.com>
cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <alpine.DEB.2.00.1110252244270.18661@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1110252311030.20273@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com> <20111025090956.GA10797@suse.de> <alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com> <CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
 <alpine.DEB.2.00.1110252244270.18661@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011, David Rientjes wrote:

> Ok, so __GFP_NORETRY it is.  Just make sure that when 
> pm_restrict_gfp_mask() masks off __GFP_IO and __GFP_FS that it also sets 
> __GFP_NORETRY even though the name of the function no longer seems 
> appropriate anymore.
> 

Or, rather, when pm_restrict_gfp_mask() clears __GFP_IO and __GFP_FS that 
it also has the same behavior as __GFP_NORETRY in should_alloc_retry() by 
setting a variable in file scope.

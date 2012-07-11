Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab2GKUl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:41:26 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:42708 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab2GKUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:41:24 -0400
Date: Wed, 11 Jul 2012 13:40:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] mm: Warn about costly page allocation
In-Reply-To: <4FFD15B2.6020001@kernel.org>
Message-ID: <alpine.DEB.2.00.1207111337430.3635@chino.kir.corp.google.com>
References: <1341878153-10757-1-git-send-email-minchan@kernel.org> <20120709170856.ca67655a.akpm@linux-foundation.org> <20120710002510.GB5935@bbox> <alpine.DEB.2.00.1207101756070.684@chino.kir.corp.google.com> <20120711022304.GA17425@bbox>
 <alpine.DEB.2.00.1207102223000.26591@chino.kir.corp.google.com> <4FFD15B2.6020001@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Minchan Kim wrote:

> I agree it's an ideal but the problem is that it's too late.
> Once product is released, we have to recall all products in the worst case.
> The fact is that lumpy have helped high order allocation implicitly but we removed it
> without any notification or information. It's a sort of regression and we can't say
> them "Please report us if it happens". It's irresponsible, too.
> IMHO, at least, what we can do is to warn about it before it's too late.
> 

High order allocations that fail should still display a warning message 
when __GFP_NOWARN is not set, so I don't see what this additional warning 
adds.  I don't think it's responsible to ask admins to know what lumpy 
reclaim is, what memory compaction is, or when a system tends to have more 
high order allocations when memory compaction would be helpful.

What we can do, though, is address bug reports as they are reported when 
high order allocations fail and previous kernels are successful.  I 
haven't seen any lately.

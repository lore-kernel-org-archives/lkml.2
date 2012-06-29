Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2F2Wuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 18:50:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45554 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2F2Wud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 18:50:33 -0400
Date: Fri, 29 Jun 2012 15:50:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Petr Holasek <pholasek@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] KSM: numa awareness sysfs knob
In-Reply-To: <20120629141759.3312b49e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1206291543360.17044@chino.kir.corp.google.com>
References: <1340970592-25001-1-git-send-email-pholasek@redhat.com> <20120629141759.3312b49e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012, Andrew Morton wrote:

> > I've tested this patch on numa machines with 2, 4 and 8 nodes and
> > measured speed of memory access inside of KVM guests with memory pinned
> > to one of nodes with this benchmark:
> > 
> > http://pholasek.fedorapeople.org/alloc_pg.c
> > 
> > Population standard deviations of access times in percentage of average
> > were following:
> > 
> > merge_nodes=1
> > 2 nodes 1.4%
> > 4 nodes 1.6%
> > 8 nodes	1.7%
> > 
> > merge_nodes=0
> > 2 nodes	1%
> > 4 nodes	0.32%
> > 8 nodes	0.018%
> 
> ooh, numbers!  Thanks.
> 

Ok, the standard deviation increases when merging pages from nodes with 
remote distance, that makes sense.  But if that's true, then you would 
restrict either the entire application to local memory with mempolicies or 
cpusets, or you would use mbind() to restrict this memory to that set of 
nodes already so that accesses, even with ksm merging, would have 
affinity.

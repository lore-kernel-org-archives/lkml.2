Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2BXKDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:03:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37695 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2BXKDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:03:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rientjes@google.com designates 10.68.74.197 as permitted sender) smtp.mail=rientjes@google.com; dkim=pass header.i=rientjes@google.com
Date: Fri, 24 Feb 2012 02:03:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
In-Reply-To: <alpine.LFD.2.02.1202240856370.1917@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1202240200380.24971@chino.kir.corp.google.com>
References: <20120222115320.GA3107@x61.redhat.com> <alpine.DEB.2.00.1202221640420.14213@chino.kir.corp.google.com> <20120223152226.GA2014@x61.redhat.com> <alpine.DEB.2.00.1202231509510.26362@chino.kir.corp.google.com>
 <alpine.LFD.2.02.1202240856370.1917@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Pekka Enberg wrote:

> Right. We should drop the sysctl and make it into a kernel command line 
> debugging option instead.
> 

I like how slub handles this when it can't allocate more slab with 
slab_out_of_memory() and has the added benefit of still warning even with 
__GFP_NORETRY that the oom killer is never called for.  If there's really 
a slab leak happening, there's a good chance that this diagnostic 
information is going to be emitted by the offending cache at some point in 
time if you're using slub.  This could easily be extended to slab.c, so 
it's even more reason not to include this type of information in the oom 
killer.

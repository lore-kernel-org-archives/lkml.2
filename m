Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab0LAFVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:21:52 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43567 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0LAFVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:21:51 -0500
Date: Wed, 1 Dec 2010 10:51:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] Move zone_reclaim() outside of CONFIG_NUMA
Message-ID: <20101201052141.GJ2746@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
 <20101130101506.17475.34536.stgit@localhost6.localdomain6>
 <20101130142338.5e845880.akpm@linux-foundation.org>
 <20101201043408.GE2746@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101201043408.GE2746@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2010-12-01 10:04:08]:

> * Andrew Morton <akpm@linux-foundation.org> [2010-11-30 14:23:38]:
> 
> > On Tue, 30 Nov 2010 15:45:12 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > This patch moves zone_reclaim and associated helpers
> > > outside CONFIG_NUMA. This infrastructure is reused
> > > in the patches for page cache control that follow.
> > > 
> > 
> > Thereby adding a nice dollop of bloat to everyone's kernel.  I don't
> > think that is justifiable given that the audience for this feature is
> > about eight people :(
> > 
> > How's about CONFIG_UNMAPPED_PAGECACHE_CONTROL?
> >
> 
> OK, I'll add the config, but this code is enabled under CONFIG_NUMA
> today, so the bloat I agree is more for non NUMA users. I'll make
> CONFIG_UNMAPPED_PAGECACHE_CONTROL default if CONFIG_NUMA is set.
>  
> > Also this patch instantiates sysctl_min_unmapped_ratio and
> > sysctl_min_slab_ratio on non-NUMA builds but fails to make those
> > tunables actually tunable in procfs.  Changes to sysctl.c are
> > needed.
> > 
> 
> Oh! yeah.. I missed it while refactoring, my fault.
> 
> > > Reviewed-by: Christoph Lameter <cl@linux.com>
> > 

My local MTA failed to deliver the message, trying again.

-- 
	Three Cheers,
	Balbir

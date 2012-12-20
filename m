Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2LTUn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:43:58 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:56835 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2LTUny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:43:54 -0500
Date: Thu, 20 Dec 2012 12:43:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/sparse: don't check return value of alloc_bootmem
 calls
In-Reply-To: <50D376E9.9030507@oracle.com>
Message-ID: <alpine.DEB.2.00.1212201238460.29839@chino.kir.corp.google.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com> <1356030701-16284-30-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212201218590.29839@chino.kir.corp.google.com> <50D376E9.9030507@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, Sasha Levin wrote:

> So what we really need is to update the documentation of __alloc_bootmem_node, I'll send
> a patch that does that instead.
> 

It panics iff slab is not available to allocate from yet, otherwise it's 
just a wrapper around kmalloc().  This emits a warning to the kernel log, 
though, so __alloc_bootmem_node() should certainly not be called that late 
in the boot sequence.

Since __alloc_bootmem_node_nopanic() is the way to avoid the panic, I 
think the change that should be made here so to panic even when the 
kmalloc() fails in __alloc_bootmem_node(), __alloc_bootmem_node_high(), 
and __alloc_bootmem_low_node().

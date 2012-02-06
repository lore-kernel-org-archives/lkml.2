Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2BFV7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:59:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65094 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2BFV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:59:08 -0500
Date: Mon, 6 Feb 2012 13:58:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Willy Tarreau <w@1wt.eu>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 02/91] slub: fix panic with DISCONTIGMEM
In-Reply-To: <20120205220949.536346997@pcw.home.local>
Message-ID: <alpine.DEB.2.00.1202061358170.3817@chino.kir.corp.google.com>
References: <20120205220949.536346997@pcw.home.local>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Feb 2012, Willy Tarreau wrote:

> commit 4a5fa3590f09999f6db41bc386bce40848fa9f63 upstream.
> 
> Slub makes assumptions about page_to_nid() which are violated by
> DISCONTIGMEM and !NUMA.  This violation results in a panic because
> page_to_nid() can be non-zero for pages in the discontiguous ranges and
> this leads to a null return by get_node().  The assertion by the
> maintainer is that DISCONTIGMEM should only be allowed when NUMA is also
> defined.  However, at least six architectures: alpha, ia64, m32r, m68k,
> mips, parisc violate this.  The panic is a regression against slab, so
> just mark slub broken in the problem configuration to prevent users
> reporting these panics.
> 
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

The problem that this patch initially addressed is fixed by the next patch 
in your series, "set memory ranges in N_NORMAL_MEMORY when onlined", so I 
don't think this one should be merged.

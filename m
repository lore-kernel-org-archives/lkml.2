Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2BGGOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:14:15 -0500
Received: from 1wt.eu ([62.212.114.60]:62277 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab2BGGOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:14:14 -0500
Date: Tue, 7 Feb 2012 07:13:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 02/91] slub: fix panic with DISCONTIGMEM
Message-ID: <20120207061357.GA26009@1wt.eu>
References: <20120205220949.536346997@pcw.home.local> <alpine.DEB.2.00.1202061358170.3817@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202061358170.3817@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 01:58:56PM -0800, David Rientjes wrote:
> On Sun, 5 Feb 2012, Willy Tarreau wrote:
> 
> > commit 4a5fa3590f09999f6db41bc386bce40848fa9f63 upstream.
> > 
> > Slub makes assumptions about page_to_nid() which are violated by
> > DISCONTIGMEM and !NUMA.  This violation results in a panic because
> > page_to_nid() can be non-zero for pages in the discontiguous ranges and
> > this leads to a null return by get_node().  The assertion by the
> > maintainer is that DISCONTIGMEM should only be allowed when NUMA is also
> > defined.  However, at least six architectures: alpha, ia64, m32r, m68k,
> > mips, parisc violate this.  The panic is a regression against slab, so
> > just mark slub broken in the problem configuration to prevent users
> > reporting these panics.
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > Acked-by: Pekka Enberg <penberg@kernel.org>
> > Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> The problem that this patch initially addressed is fixed by the next patch 
> in your series, "set memory ranges in N_NORMAL_MEMORY when onlined", so I 
> don't think this one should be merged.

Perfect, I'm dropping it then.

Thank you David,
Willy


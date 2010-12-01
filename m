Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0LAAag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:30:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab0LAAaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:30:35 -0500
Date: Tue, 30 Nov 2010 16:29:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC] vmalloc: eagerly clear ptes on vunmap
Message-Id: <20101130162938.8a6b0df4.akpm@linux-foundation.org>
In-Reply-To: <4CF40DCB.5010007@goop.org>
References: <4CEF6B8B.8080206@goop.org>
	<20101127103656.GA6884@amd>
	<4CF40DCB.5010007@goop.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 12:32:11 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When unmapping a region in the vmalloc space, clear the ptes immediately.
> There's no point in deferring this because there's no amortization
> benefit.
> 
> The TLBs are left dirty, and they are flushed lazily to amortize the
> cost of the IPIs.
> 
> This specific motivation for this patch is a regression since 2.6.36 when
> using NFS under Xen, triggered by the NFS client's use of vm_map_ram()
> introduced in 56e4ebf877b6043c289bda32a5a7385b80c17dee.  XFS also uses
> vm_map_ram() and could cause similar problems.
> 

Do we have any quantitative info on that regression?  The patch fixed
it, I assume?


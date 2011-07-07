Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1GGM6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:58:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56074
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516Ab1GGM6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:58:37 -0400
Date: Thu, 7 Jul 2011 08:58:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/14] Swap-over-NBD without deadlocking v5
Message-ID: <20110707125831.GA15412@infradead.org>
References: <1308575540-25219-1-git-send-email-mgorman@suse.de>
 <20110706165146.be7ab61b.akpm@linux-foundation.org>
 <20110707094737.GG15285@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707094737.GG15285@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 10:47:37AM +0100, Mel Gorman wrote:
> Additional complexity is required for swap-over-NFS but affects the
> core kernel far less than this series. I do not have a series prepared
> but from what's in a distro kernel, supporting NFS requires extending
> address_space_operations for swapfile activation/deactivation with
> some minor helpers and the bulk of the remaining complexity within
> NFS itself.

The biggest addition for swap over NFS is to add proper support for
a filesystem interface to do I/O on random kernel pages instead of
the current nasty bmap hack the swapfile code is using.  Splitting
that work from all the required VM infrastructure should make life
easier for everyone involved and allows merging it independeny as
both bits have other uses case as well.


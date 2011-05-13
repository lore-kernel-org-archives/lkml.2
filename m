Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab1EMKcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:32:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab1EMKcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:32:06 -0400
Date: Fri, 13 May 2011 06:32:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peng Huang <shawn.p.huang@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfs: check a crash in nfs_lookup_revalidate
Message-ID: <20110513103202.GA27578@infradead.org>
References: <1305147805-5756-1-git-send-email-shawn.p.huang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305147805-5756-1-git-send-email-shawn.p.huang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 05:03:25PM -0400, Peng Huang wrote:
> lookup_one_len() may call nfs_loopup_revalidate() with nd == NULL
> indirectly, that causes the kernel crash.

lookup_one_len must only be called by a filesystem or a library function
called by the filesystem.  You are not allowed to call it on a random
filesystem like nfs that doesn't support the underlying assumptions.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0K2O7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:59:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0K2O7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:59:37 -0500
Date: Mon, 29 Nov 2010 09:59:37 -0500
From: Christoph Hellwig <hch@infradead.org>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/7] fs: preserve inode dirty bits on failed metadata
 writeback
Message-ID: <20101129145936.GC26076@infradead.org>
References: <20101123140610.292941494@kernel.dk>
 <20101123140707.922192750@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123140707.922192750@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 01:06:14AM +1100, npiggin@kernel.dk wrote:
> Otherwise we think the inode is clean even if syncing failed.

The patch itself looks fine, but I'm not sure it's enough.  If we do
an synchronous writeout it could fail long after ->write_inode
has returned.


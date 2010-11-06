Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0KFSGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:06:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0KFSGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:06:45 -0400
Date: Sat, 6 Nov 2010 14:06:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] udf: Remove unnecessary bkl usages
Message-ID: <20101106180639.GC13315@infradead.org>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
 <1289065631-2256-2-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289065631-2256-2-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 06:47:09PM +0100, Alessio Igor Bogani wrote:
> The udf_lookup, udf_create, udf_mknod, udf_mkdir, udf_rmdir, udf_link,
> udf_unlink and udf_readdir functions seems already adequately protected
> by i_mutex held by VFS invoking calls. The udf_rename function instead
> should be already protected by lock_rename again by VFS.
> 
> The udf_get_parent, udf_count_free_bitmap, udf_count_free_table and
> udf_put_super functions don't require any protection.

This looks correct to me.  But I'd suggest to reorder it to be the last
patch in the series, after the fine grained locking for the low level
code has been in place.


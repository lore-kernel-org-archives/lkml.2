Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab1FGXEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:04:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148Ab1FGXE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:04:28 -0400
Date: Tue, 7 Jun 2011 16:03:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/15] writeback: split inode_wb_list_lock into
 bdi_writeback.list_lock
Message-Id: <20110607160319.57f27481.akpm@linux-foundation.org>
In-Reply-To: <20110607213854.267319164@intel.com>
References: <20110607213236.634026193@intel.com>
	<20110607213854.267319164@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011 05:32:43 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

>  static void bdev_inode_switch_bdi(struct inode *inode,
>  			struct backing_dev_info *dst)
>  {
> -	spin_lock(&inode_wb_list_lock);
> +	struct backing_dev_info *old = inode->i_data.backing_dev_info;
> +
> +	if (unlikely(dst == old))		/* deadlock avoidance */
> +		return;

Why does this occur?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0JMPFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:05:49 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48302 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0JMPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:05:48 -0400
Date: Wed, 13 Oct 2010 11:05:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101013150547.GA12757@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-10-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +/**
> + * hlist_bl_lock	- lock a hash list
> + * @h:	hash list head to lock
> + */
> +static inline void hlist_bl_lock(struct hlist_bl_head *h)
> +{
> +	bit_spin_lock(0, (unsigned long *)h);
> +}
> +
> +/**
> + * hlist_bl_unlock	- unlock a hash list
> + * @h:	hash list head to unlock
> + */
> +static inline void hlist_bl_unlock(struct hlist_bl_head *h)
> +{
> +	__bit_spin_unlock(0, (unsigned long *)h);
> +}

I think the locking helpers should come with the rest of the bl_list
implementation in patch1.

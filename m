Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0I3CMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:12:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0I3CMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:12:38 -0400
Date: Wed, 29 Sep 2010 22:12:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>, dada1@cosmosbay.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] fs: Convert nr_inodes to a per-cpu counter
Message-ID: <20100930021237.GD1535@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-17-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-17-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Handle nr_dentry sysctl
> + */
> +int proc_nr_inodes(ctl_table *table, int write,
> +		   void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
> +	inodes_stat.nr_inodes = get_nr_inodes();
> +	return proc_dointvec(table, write, buffer, lenp, ppos);
> +#else
> +	return -ENOSYS;
> +#endif
> +}

Why would we even bother to define the handler if we don't have
/proc/sys/ support?


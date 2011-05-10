Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1EJIAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:00:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab1EJIAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:00:35 -0400
Date: Tue, 10 May 2011 04:00:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/14] HPFS: Introduce a global mutex and lock it on every
 callback from VFS.
Message-ID: <20110510080030.GA13420@infradead.org>
References: <alpine.DEB.2.00.1105082024500.7013@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105082024500.7013@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static inline void hpfs_lock(struct super_block *s)
>  {
> +	struct hpfs_sb_info *sbi = hpfs_sb(s);
> +	mutex_lock(&sbi->hpfs_mutex);
>  }
>  
>  static inline void hpfs_unlock(struct super_block *s)
>  {
> +	struct hpfs_sb_info *sbi = hpfs_sb(s);
> +	mutex_unlock(&sbi->hpfs_mutex);
> +}
> +
> +static inline void hpfs_lock_assert(struct super_block *s)
> +{
> +	struct hpfs_sb_info *sbi = hpfs_sb(s);
> +	WARN_ON(!mutex_is_locked(&sbi->hpfs_mutex));
>  }

These locks just obsfucate what's going on.  Just call the mutex
helpers directly.


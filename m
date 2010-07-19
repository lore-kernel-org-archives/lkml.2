Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624Ab0GSOzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:55:06 -0400
Received: from verein.lst.de ([213.95.11.210]:43398 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935418Ab0GSOzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:55:02 -0400
Date: Mon, 19 Jul 2010 16:54:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] [fs/sysv] V7: Adjust sanity checks for some volumes
Message-ID: <20100719145457.GC25279@lst.de>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk> <1279559802-19154-2-git-send-email-lkundrak@v3.sk> <1279559802-19154-3-git-send-email-lkundrak@v3.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279559802-19154-3-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	if (fs16_to_cpu(sbi, v7sb->s_nfree) > V7_NICFREE ||
>  	    fs16_to_cpu(sbi, v7sb->s_ninode) > V7_NICINOD ||
> -	    fs32_to_cpu(sbi, v7sb->s_time) == 0)
> -		goto failed;
> +	    fs32_to_cpu(sbi, v7sb->s_fsize) > V7_MAXSIZE)
> +		return 0;

Ok.

>  	v7i = (struct sysv_inode *)(bh2->b_data + 64);
>  	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
>  	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
> -	    (fs32_to_cpu(sbi, v7i->i_size) & 017) != 0)
> +	    (fs32_to_cpu(sbi, v7i->i_size) & 017)
> +	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
> +	     sizeof (struct sysv_dir_entry))) {

Maybe I'm missing something, but without and additional || on the
first line you added this doesn't look like it will compile.


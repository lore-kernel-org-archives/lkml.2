Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1C3LHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:07:53 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:35162 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1C3LHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:07:52 -0400
X-ASG-Debug-ID: 1301483270-01de284cf8daeb0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D930F02.4070409@fusionio.com>
Date: Wed, 30 Mar 2011 13:07:46 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
CC: linux-nilfs <linux-nilfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
References: <20110330.132555.158630340.ryusuke@osrg.net>
X-ASG-Orig-Subj: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
In-Reply-To: <20110330.132555.158630340.ryusuke@osrg.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301483270
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59400
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 06:25, Ryusuke Konishi wrote:
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 4d2a1ee..9d2dc6b 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -495,12 +495,14 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
>  void nilfs_mapping_init(struct address_space *mapping,
>  			struct backing_dev_info *bdi)
>  {
> +	static const struct address_space_operations empty_aops;
> +
>  	mapping->host = NULL;
>  	mapping->flags = 0;
>  	mapping_set_gfp_mask(mapping, GFP_NOFS);
>  	mapping->assoc_mapping = NULL;
>  	mapping->backing_dev_info = bdi;
> -	mapping->a_ops = NULL;
> +	mapping->a_ops = &empty_aops;
>  }

Hmm wait, inode init should set the mapping aops to an empty type
already. Does the OOPS go away if you just remove the mapping->a_ops =
NULL assignment?

-- 
Jens Axboe


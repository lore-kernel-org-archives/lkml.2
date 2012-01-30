Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2A3R37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:29:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab2A3R35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:29:57 -0500
Date: Mon, 30 Jan 2012 18:23:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup of rw_copy_check_uvector and
	compat_rw_copy_check_uvector
Message-ID: <20120130172337.GA12696@redhat.com>
References: <20120130145114.4c084a6a@Gantu.yeoh.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130145114.4c084a6a@Gantu.yeoh.info>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Christopher Yeoh wrote:
>
>  ssize_t compat_rw_copy_check_uvector(int type,
>  		const struct compat_iovec __user *uvector, unsigned long nr_segs,
>  		unsigned long fast_segs, struct iovec *fast_pointer,
> -		struct iovec **ret_pointer, int check_access)
> +		struct iovec **ret_pointer)
>  {
>  	compat_ssize_t tot_len;
>  	struct iovec *iov = *ret_pointer = fast_pointer;
> @@ -586,7 +586,7 @@ ssize_t compat_rw_copy_check_uvector(int type,
>  		}
>  		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
>  			goto out;
> -		if (check_access &&
> +		if (type >=0 &&

I bet checkpatch.pl will complain, this needs the space after '>' ;)

Otherwise this is nice cleanup, imho.

Christopher, this is up to Andrew but perhaps you should update
the changelog. It should explain what this patch does (overload
"int type", remove the unnecessary "check_access", etc). It should
not simply mention the previous discussion.

Oleg.


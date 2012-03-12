Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2CLKsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:48:10 -0400
Received: from mailout11.t-online.de ([194.25.134.85]:46343 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2CLKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:48:07 -0400
Message-ID: <e7d66e1ec32441e07e70f73581288dfd.squirrel@www.ontika.net>
In-Reply-To: <20120308072551.GA27713@elgon.mountain>
References: <20120308072551.GA27713@elgon.mountain>
Date: Mon, 12 Mar 2012 11:47:56 +0100
Subject: Re: [patch] qnx6fs: silence a Sparse warning
From: "Kai Bankett" <chaosman@ontika.net>
To: "Dan Carpenter" <dan.carpenter@oracle.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-ID: EB9+BmZT8hchxMG2y+K3cpNs1shWwcJYMf0PBOPwOi-KXotBkRN5L8wLsT7XglQZ8b@t-dialin.net
X-TOI-MSGID: 686536e5-1165-4f97-9a67-07174ed9bfcf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

thank you very much for the provided fix.
I've successfully applied and tested it. (well, did not expect much to
happen, but just to be on the safe side)
I will include it in my next version.

Thanks,

Kai

> Add a  __force to silence a sparse warning:
> 	fs/qnx6/inode.c:88:22: warning: cast to restricted __fs32
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
> index e44012d..acf9241 100644
> --- a/fs/qnx6/inode.c
> +++ b/fs/qnx6/inode.c
> @@ -85,7 +85,7 @@ static int qnx6_get_block(struct inode *inode, sector_t
> iblock,
>
>  static int qnx6_check_blockptr(__fs32 ptr)
>  {
> -	if (ptr == ~(__fs32)0) {
> +	if (ptr == ~(__force __fs32)0) {
>  		printk(KERN_ERR "qnx6: hit unused blockpointer.\n");
>  		return 0;
>  	}
>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2K1PKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:10:10 -0500
Received: from fieldses.org ([174.143.236.118]:47396 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab2K1PKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:10:08 -0500
Date: Wed, 28 Nov 2012 10:10:06 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, Trond.Myklebust@netapp.com,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/2] nfsd: make NFSv4 grace time per net
Message-ID: <20121128151006.GG11651@fieldses.org>
References: <20121127111007.10271.54338.stgit@localhost.localdomain>
 <20121127111149.10271.51541.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127111149.10271.51541.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:11:49PM +0300, Stanislav Kinsbursky wrote:
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index 4930981..7e41bd1 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -928,7 +928,8 @@ static ssize_t write_leasetime(struct file *file, char *buf, size_t size)
>   */
>  static ssize_t write_gracetime(struct file *file, char *buf, size_t size)
>  {
> -	return nfsd4_write_time(file, buf, size, &nfsd4_grace);
> +	struct nfsd_net *nn = net_generic(&init_net, nfsd_net_id);
> +	return nfsd4_write_time(file, buf, size, &nn->nfsd4_grace);
>  }

Same comment as for lease time.--b.

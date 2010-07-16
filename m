Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab0GPQfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:35:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39447 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab0GPQfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:35:34 -0400
Subject: Re: [PATCH 10/15] fs: cifs: check kmalloc() result
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Steve French <sfrench@samba.org>,
        Jeff Layton <jlayton@redhat.com>, Tejun Heo <tj@kernel.org>,
        Joe Perches <joe@perches.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <1279296925-25147-1-git-send-email-segooon@gmail.com>
References: <1279296925-25147-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Organization: IBM Linux Technology Center
Date: Fri, 16 Jul 2010 11:35:30 -0500
Message-ID: <1279298130.26876.12.camel@shaggy-w500>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 20:15 +0400, Kulikov Vasiliy wrote:
> If kmalloc() fails exit with -ENOMEM.

Looks good to me.  Add my ack if you want it.

> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> ---
>  fs/cifs/readdir.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index daf1753..d5e591f 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -847,6 +847,11 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  		end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
> 
>  		tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
> +		if (tmp_buf == NULL) {
> +			rc = -ENOMEM;
> +			break;
> +		}
> +
>  		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
>  			if (current_entry == NULL) {
>  				/* evaluate whether this case is an error */

-- 
Dave Kleikamp
IBM Linux Technology Center


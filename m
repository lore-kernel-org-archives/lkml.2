Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2AaKmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:42:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab2AaKmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:42:44 -0500
Date: Tue, 31 Jan 2012 05:42:31 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH -next] cifs: fix printk format warnings
Message-ID: <20120131054231.66669e41@tlielax.poochiereds.net>
In-Reply-To: <4F2764E9.4010506@xenotime.net>
References: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
	<4F2764E9.4010506@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 19:50:01 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warnings for ssize_t variables:
> 
> fs/cifs/connect.c:2145:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
> fs/cifs/connect.c:2152:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
> fs/cifs/connect.c:2160:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
> fs/cifs/connect.c:2170:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	Steve French <sfrench@samba.org>
> Cc:	linux-cifs@vger.kernel.org
> ---
>  fs/cifs/connect.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- linux-next-20120130.orig/fs/cifs/connect.c
> +++ linux-next-20120130/fs/cifs/connect.c
> @@ -2142,14 +2142,14 @@ cifs_set_cifscreds(struct smb_vol *vol,
>  
>  	len = delim - payload;
>  	if (len > MAX_USERNAME_SIZE || len <= 0) {
> -		cFYI(1, "Bad value from username search (len=%ld)", len);
> +		cFYI(1, "Bad value from username search (len=%zd)", len);
>  		rc = -EINVAL;
>  		goto out_key_put;
>  	}
>  
>  	vol->username = kstrndup(payload, len, GFP_KERNEL);
>  	if (!vol->username) {
> -		cFYI(1, "Unable to allocate %ld bytes for username", len);
> +		cFYI(1, "Unable to allocate %zd bytes for username", len);
>  		rc = -ENOMEM;
>  		goto out_key_put;
>  	}
> @@ -2157,7 +2157,7 @@ cifs_set_cifscreds(struct smb_vol *vol,
>  
>  	len = key->datalen - (len + 1);
>  	if (len > MAX_PASSWORD_SIZE || len <= 0) {
> -		cFYI(1, "Bad len for password search (len=%ld)", len);
> +		cFYI(1, "Bad len for password search (len=%zd)", len);
>  		rc = -EINVAL;
>  		kfree(vol->username);
>  		vol->username = NULL;
> @@ -2167,7 +2167,7 @@ cifs_set_cifscreds(struct smb_vol *vol,
>  	++delim;
>  	vol->password = kstrndup(delim, len, GFP_KERNEL);
>  	if (!vol->password) {
> -		cFYI(1, "Unable to allocate %ld bytes for password", len);
> +		cFYI(1, "Unable to allocate %zd bytes for password", len);
>  		rc = -ENOMEM;
>  		kfree(vol->username);
>  		vol->username = NULL;

Looks correct.

Acked-by: Jeff Layton <jlayton@redhat.com>

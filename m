Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0JEXaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:30:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39065 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab0JEXaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:30:15 -0400
Message-ID: <4CABB504.2030606@linux.vnet.ibm.com>
Date: Tue, 05 Oct 2010 16:30:12 -0700
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 3/3] fs/9p: Use generic_file_open with
 lookup_instantiate_filp
References: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1286298090-2422-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1286298090-2422-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2010 10:01 AM, Aneesh Kumar K.V wrote:
> We need to do O_LARGEFILE check even in case of 9p. Use the
> generic_file_open helper
>
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>

Looks good to me

Reviewed by : Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>

> ---
>   fs/9p/vfs_inode.c |   11 ++---------
>   1 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 1ac9229..44ce77d 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -560,13 +560,6 @@ static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
>   	return retval;
>   }
>
> -static int
> -v9fs_open_created(struct inode *inode, struct file *file)
> -{
> -	return 0;
> -}
> -
> -
>   /**
>    * v9fs_create - Create a file
>    * @v9ses: session information
> @@ -766,7 +759,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>
>   	/* if we are opening a file, assign the open fid to the file */
>   	if (nd&&  nd->flags&  LOOKUP_OPEN) {
> -		filp = lookup_instantiate_filp(nd, dentry, v9fs_open_created);
> +		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
>   		if (IS_ERR(filp)) {
>   			p9_client_clunk(ofid);
>   			return PTR_ERR(filp);
> @@ -825,7 +818,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
>
>   	/* if we are opening a file, assign the open fid to the file */
>   	if (nd&&  nd->flags&  LOOKUP_OPEN) {
> -		filp = lookup_instantiate_filp(nd, dentry, v9fs_open_created);
> +		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
>   		if (IS_ERR(filp)) {
>   			err = PTR_ERR(filp);
>   			goto error;



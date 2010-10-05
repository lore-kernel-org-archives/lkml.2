Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab0JEX3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:29:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52290 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab0JEX3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:29:05 -0400
Message-ID: <4CABB4BD.6050705@linux.vnet.ibm.com>
Date: Tue, 05 Oct 2010 16:29:01 -0700
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 2/3] fs/9p: Add missing iput in v9fs_vfs_lookup
References: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1286298090-2422-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1286298090-2422-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2010 10:01 AM, Aneesh Kumar K.V wrote:
> Make sure we drop inode reference in the error path
>
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>

Looks good to me.

Reviewed-by : Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>

> ---
>   fs/9p/vfs_inode.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 1ec9075..1ac9229 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -1028,7 +1028,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
>
>   	result = v9fs_fid_add(dentry, fid);
>   	if (result<  0)
> -		goto error;
> +		goto error_iput;
>
>   inst_out:
>   	if (v9ses->cache)
> @@ -1039,6 +1039,8 @@ inst_out:
>   	d_add(dentry, inode);
>   	return NULL;
>
> +error_iput:
> +	iput(inode);
>   error:
>   	p9_client_clunk(fid);
>



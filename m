Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1CYV1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:27:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33803 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1CYV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:27:10 -0400
Message-ID: <4D8D08A7.1090706@linux.vnet.ibm.com>
Date: Fri, 25 Mar 2011 14:27:03 -0700
From: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 4/5] fs/9p: Fix error reported by coccicheck
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1301052651-21440-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1301052651-21440-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2011 04:30 AM, Aneesh Kumar K.V wrote:
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by : Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
> ---
>   fs/9p/vfs_inode_dotl.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> index ffbb113..82a7c38 100644
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@ -811,7 +811,7 @@ v9fs_vfs_follow_link_dotl(struct dentry *dentry, struct nameidata *nd)
>   	fid = v9fs_fid_lookup(dentry);
>   	if (IS_ERR(fid)) {
>   		__putname(link);
> -		link = ERR_PTR(PTR_ERR(fid));
> +		link = ERR_CAST(fid);
>   		goto ndset;
>   	}
>   	retval = p9_client_readlink(fid,&target);


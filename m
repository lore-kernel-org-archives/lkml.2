Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2CVOVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:21:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:22212 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab2CVOV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <1332356057-3356-9-git-send-email-zohar@linux.vnet.ibm.com>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1332356057-3356-9-git-send-email-zohar@linux.vnet.ibm.com>
Date: Thu, 22 Mar 2012 16:21:26 +0200
Message-ID: <CALLzPKYuMhqRU2=Kq2TsOjsp=UNb4CP5_QC=cQ6s_sLhX_mncw@mail.gmail.com>
Subject: Re: [PATCH v3 08/12] ima: add inode_post_setattr call
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 8:54 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Changing an inode's metadata may result in our not needing to appraise
> the file.  In such cases, we must remove 'security.ima'.
>
> Changelog v1:
> - use ima_inode_post_setattr() stub function, if IMA_APPRAISE not configured
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

> ---
>  fs/attr.c           |    2 ++
>  include/linux/ima.h |   10 ++++++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/fs/attr.c b/fs/attr.c
> index d9bd7fc..f496bac 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -14,6 +14,7 @@
>  #include <linux/fcntl.h>
>  #include <linux/security.h>
>  #include <linux/evm.h>
> +#include <linux/ima.h>
>
>  /**
>  * inode_change_ok - check if attribute changes to an inode are allowed
> @@ -245,6 +246,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
>
>        if (!error) {
>                fsnotify_change(dentry, ia_valid);
> +               ima_inode_post_setattr(dentry);
>                evm_inode_post_setattr(dentry, ia_valid);
>        }
>
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index 6ac8e50..e2bfbb1 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -39,5 +39,15 @@ static inline int ima_file_mmap(struct file *file, unsigned long prot)
>  {
>        return 0;
>  }
> +
>  #endif /* CONFIG_IMA_H */
> +
> +#ifdef CONFIG_IMA_APPRAISE
> +extern void ima_inode_post_setattr(struct dentry *dentry);
> +#else
> +static inline void ima_inode_post_setattr(struct dentry *dentry)
> +{
> +       return;
> +}
> +#endif /* CONFIG_IMA_APPRAISE_H */
>  #endif /* _LINUX_IMA_H */
> --
> 1.7.6.5
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2LKOJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:09:18 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37703 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab2LKOJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:09:13 -0500
Message-ID: <1355234940.2356.86.camel@falcor>
Subject: Re: [PATCH 1/2] vfs: new super block feature flags attribute
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: viro@zeniv.linux.org.uk, fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Dec 2012 09:09:00 -0500
In-Reply-To: <a88c4edfd91ba518cd1094b94a7a5cd59a003c78.1353588575.git.dmitry.kasatkin@intel.com>
References: <a88c4edfd91ba518cd1094b94a7a5cd59a003c78.1353588575.git.dmitry.kasatkin@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121114-5806-0000-0000-00001CD48486
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-22 at 14:49 +0200, Dmitry Kasatkin wrote:
> This patch introduces new super block attribute flag s_feature_flags
> and SF_IMA_DISABLED flag. This flag will be used by Integrity Measurement
> Architecture (IMA). Name suggested by Bruce Fields.

The patch looks good.  The patch description should reflect the
discussion with Al https://lkml.org/lkml/2012/9/19/9, explanining 'why'
a new flag is needed.

> Certain file system types and partitions will never be measured or
> appraised by IMA depending on the policy. For example, pseudo file
> systems are never measured and appraised. In current implementation
> policy will be checked again and again. It happens thousands times
> per second. That is absolute waste of CPU and may be battery resources.
> 
> IMA will set the SF_IMA_DISABLED flag when file system will not be measured
> and appraised and test this flag during subsequent calls to skip policy search.

This explanation belongs in the subsequent patch, which makes use of the
flag.

> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>


> ---
>  include/linux/fs.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b33cfc9..0bef2b2 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1321,6 +1321,8 @@ struct super_block {
> 
>  	/* Being remounted read-only */
>  	int s_readonly_remount;
> +
> +	unsigned long s_feature_flags;
>  };
> 
>  /* superblock cache pruning functions */
> @@ -1746,6 +1748,8 @@ struct super_operations {
> 
>  #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
> 

Comment needed here before the start of the feature flag definitions.

> +#define SF_IMA_DISABLED		0x0001
> +
>  extern void __mark_inode_dirty(struct inode *, int);
>  static inline void mark_inode_dirty(struct inode *inode)
>  {

thanks,

Mimi


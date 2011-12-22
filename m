Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab1LVN3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 08:29:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55888 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1LVN3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 08:29:19 -0500
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Dec 2011 08:26:30 -0500
In-Reply-To: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324560391.1964.8.camel@falcor>
Mime-Version: 1.0
x-cbid: 11122213-1780-0000-0000-000001D29377
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000242; HX=3.00000180; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00098310; UDB=6.00025448; UTC=2011-12-22
 13:29:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 12:54 +0200, Dmitry Kasatkin wrote:
> When a file is truncated with truncate()/ftruncate() and then closed,
> iversion is not updated. This patch uses ATTR_SIZE flag as an indication
> to increment iversion.
> 
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

Acked-by: Mimi Zohar <zohar@us.ibm.com> 
(Stable should be cc'ed on this patch.)

thanks,

Mimi

> ---
>  fs/attr.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index 7ee7ba4..b8f55c4 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -176,6 +176,11 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
>  			return -EPERM;
>  	}
> 
> +	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
> +		if (attr->ia_size != inode->i_size)
> +			inode_inc_iversion(inode);
> +	}
> +
>  	if ((ia_valid & ATTR_MODE)) {
>  		mode_t amode = attr->ia_mode;
>  		/* Flag setting protected by i_mutex */



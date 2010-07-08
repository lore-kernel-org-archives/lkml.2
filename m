Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0GHMud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:50:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53804 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0GHMub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:50:31 -0400
Subject: Re: [PATCH 13/18] ima: use generic_file_llseek for securityfs
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org
In-Reply-To: <1278538820-1392-14-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
	 <1278538820-1392-14-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 08:50:15 -0400
Message-ID: <1278593415.3313.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-07 at 23:40 +0200, Arnd Bergmann wrote:
> The default for llseek will change to no_llseek,
> so securityfs users need to add explicit .llseek
> assignments. Since we're dealing with regular
> files from a VFS perspective, use generic_file_llseek.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mimi Zohar <zohar@us.ibm.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: linux-security-module@vger.kernel.org

As both the 'violations' and 'runtime_measurement_counts' are single
values and 'policy' doesn't support read, this patch doesn't hurt, but
adding .llseek is probably unnecessary.

thanks,

Mimi

> ---
>  security/integrity/ima/ima_fs.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index 8fe736a..ef21b96 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -45,7 +45,8 @@ static ssize_t ima_show_htable_violations(struct file *filp,
>  }
> 
>  static const struct file_operations ima_htable_violations_ops = {
> -	.read = ima_show_htable_violations
> +	.read = ima_show_htable_violations,
> +	.llseek = generic_file_llseek,
>  };
> 
>  static ssize_t ima_show_measurements_count(struct file *filp,
> @@ -57,7 +58,8 @@ static ssize_t ima_show_measurements_count(struct file *filp,
>  }
> 
>  static const struct file_operations ima_measurements_count_ops = {
> -	.read = ima_show_measurements_count
> +	.read = ima_show_measurements_count,
> +	.llseek = generic_file_llseek,
>  };
> 
>  /* returns pointer to hlist_node */
> @@ -319,7 +321,8 @@ static int ima_release_policy(struct inode *inode, struct file *file)
>  static const struct file_operations ima_measure_policy_ops = {
>  	.open = ima_open_policy,
>  	.write = ima_write_policy,
> -	.release = ima_release_policy
> +	.release = ima_release_policy,
> +	.llseek = generic_file_llseek,
>  };
> 
>  int __init ima_fs_init(void)



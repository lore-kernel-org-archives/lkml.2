Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422641Ab2KIBqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:46:51 -0500
Received: from smtp107.biz.mail.ne1.yahoo.com ([98.138.207.14]:45601 "HELO
	smtp107.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757259Ab2KIBqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:46:49 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1c2fvhkVM1k09NrDpmZEKqJZ.bJFZEJ0AMytC3fkQC77Z4n
 t8GF6QZMFajO4rZfN4LT1RO4xtXw0tq_0YzSWMGBIDuWo484kaYRpZY0JkLO
 w5bl5WP6FLxLGPPESJbCjvVMBRx952VhorOIbzfu.POrlzkGJiwjX1CdYYna
 45h3.6jMIl.F3_KMcj74XzLz4feVAFr.oXpDuKZMED_hqbtQNNNkFHtGUuNy
 uXMmObr4gIbgS52E8Pi7I6Gj6xrcS8Ayh9zUd4GpdIotN6eANtVhXpw0heZG
 u4HQL0QmOFLam7sMFyw.QBqQQ7RSN49qQETsLVrzaYYLFdo0WeP0SnF.agkU
 gne6QdpaLoT3KtPgexTnXGipuGcp0LQaxsXdM54ctpUfG1E_6e1nlROOD74k
 u6_0be8SWWnwy_Vf82wvpNOvn55vlwexz5Da9PwBVnva0cUE7QvzjlLebrSD
 TlWHs.2Wa
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <509C6087.3090400@schaufler-ca.com>
Date: Thu, 08 Nov 2012 17:46:47 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
CC: james.l.morris@oracle.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] smack: SMACK_MAGIC to include/uapi/linux/magic.h
References: <1352398094-1862-1-git-send-email-jarkko.sakkinen@iki.fi>
In-Reply-To: <1352398094-1862-1-git-send-email-jarkko.sakkinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/8/2012 10:08 AM, Jarkko Sakkinen wrote:
> SMACK_MAGIC moved to a proper place for easy user space access
> (i.e. libsmack).
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>

I will apply once James updates the next branch of his security tree.

> ---
>  include/uapi/linux/magic.h |    1 +
>  security/smack/smack.h     |    6 +-----
>  security/smack/smack_lsm.c |    1 -
>  3 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index e15192c..12735ad 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -11,6 +11,7 @@
>  #define DEBUGFS_MAGIC          0x64626720
>  #define SECURITYFS_MAGIC	0x73636673
>  #define SELINUX_MAGIC		0xf97cff8c
> +#define SMACK_MAGIC		0x43415d53	/* "SMAC" */
>  #define RAMFS_MAGIC		0x858458f6	/* some random number */
>  #define TMPFS_MAGIC		0x01021994
>  #define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 99b3612..e3e7a4f 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -21,6 +21,7 @@
>  #include <linux/list.h>
>  #include <linux/rculist.h>
>  #include <linux/lsm_audit.h>
> +#include <linux/magic.h>
>  
>  /*
>   * Smack labels were limited to 23 characters for a long time.
> @@ -149,11 +150,6 @@ struct smack_known {
>  #define SMACK_CIPSO_SOCKET	1
>  
>  /*
> - * smackfs magic number
> - */
> -#define SMACK_MAGIC	0x43415d53 /* "SMAC" */
> -
> -/*
>   * CIPSO defaults.
>   */
>  #define SMACK_CIPSO_DOI_DEFAULT		3	/* Historical */
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 38be92c..6e8fa99 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -32,7 +32,6 @@
>  #include <linux/pipe_fs_i.h>
>  #include <net/cipso_ipv4.h>
>  #include <linux/audit.h>
> -#include <linux/magic.h>
>  #include <linux/dcache.h>
>  #include <linux/personality.h>
>  #include <linux/msg.h>


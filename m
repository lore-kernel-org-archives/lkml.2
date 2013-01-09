Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab3AITPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:15:11 -0500
Received: from nm13-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.13]:45789
	"EHLO nm13-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932420Ab3AITPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:15:09 -0500
X-Yahoo-Newman-Id: 605639.95625.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JRYPvWoVM1khUWwAvSXh5tU2EtwRfHjdWSMkyZGl7pNAaDW
 FxUfzz.g4lplVhms23cUkS1jn.Qn5nI9R7kZ6MHd.ubN1s6I0WVqyAWkvR.H
 gW.1gKKxNpUe.PGc0aQnQHta7_WnrmSJ9RqBtjBb7dubHrLruM0pJ6A8bIbW
 VKdjIB438vYNp0BjSan5m0o0qL8CSfglZV2I7acY15o8bo5JLpHrDuHLKl4H
 moS2qrxEQMtaXFatZgARvKvhbx3HNBNY7mhCbrcNmez8UBAA5t9V.Jf561xS
 Bo3EUVf1YYu0BL71Wbg5EH2LUwo.oPnNvX4X9LrGtXG5vmuY_45CTJ3b1..G
 3uf3dgYdDunfTCpVnPRFJK80ioA0iojGNR0mMCnwDzJIUE1HAHoAYKKx7aEy
 xrW73j_0tLKsLPoi2.Sh0UXgmPftANWjxI6Kdas9YTQCwiy4zE0pbmSUAMYd
 eAj3xi541e1pj8KZLewx.bjr7oFvCKDNwbdcT1hZp.fFbnD.Af3nFrMlPdep
 q9cQUTeeJ.Y37.MIqm9FOe2IxhdDVDzsgR_c68JjF8Rk-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EDC1C6.5090709@schaufler-ca.com>
Date: Wed, 09 Jan 2013 11:15:18 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
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

Applied to git://git.gitorious.org/smack-next/kernel.git#stage-for-3.9

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


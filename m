Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1JKA17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:27:59 -0400
Received: from nm26-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.225]:38184
	"HELO nm26-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751061Ab1JKA16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:27:58 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Oct 2011 20:27:58 EDT
X-Yahoo-Newman-Id: 33448.35991.bm@smtp102.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MyaGRaMVM1nJ9SXIOD6hRH9_EiR8XiMV9qZg369dfVf3dPu
 nK_VfbqUoQvawCWni6_84I3SnRG2Ffmf2hkVeHYLtqJaPZXRi5n3fRkifcrp
 F4nACzfVcQnk5VsBlNDFtWrIj5fHgJ1lp7OIN0VUGjrhTfjrenSVdjV74wtj
 ieyt1jwi1QO9ibGz7vxYbr1MRcNBVys4r9Bg35.vT2TRl1nkL79VMYIHHHjv
 _gOiH5qPVyzjMewi8aY.MiOaVt9PeLewLfUfTVGDTagXKMDjXlbgbtnGzLdx
 iSimqmk.cZy6EETK7ltl0H6uHigilRSSskH7bp.WrxE4ynK7yTupHwfWQxYp
 jnCGw9iqS.fjRE82qdEpbLNHiqDCBh5I2LfFl.q60lNN7t64r7I4QhlR5fp2
 irBTUhFkd3zu4aVHK_0TGrlP2JquxUsOgBa5AFeMqF1qMw8HOCACKgFhXk8O
 U.Lh6tbpM7tSDqA9a1wTxTVmkaDZ.X98Pn_cCDIl3dWk30J8-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E938C08.2070801@schaufler-ca.com>
Date: Mon, 10 Oct 2011 17:21:28 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: fix for /smack/access output, use string instead
 of byte
References: <1318246168-26660-1-git-send-email-jarkko.sakkinen@intel.com>
In-Reply-To: <1318246168-26660-1-git-send-email-jarkko.sakkinen@intel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 4:29 AM, Jarkko Sakkinen wrote:
> Small fix for the output of access SmackFS file. Use string
> is instead of byte. Makes it easier to extend API if it is
> needed.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

Applied to git://gitorious.org/smack-next/kernel.git

> ---
>  security/smack/smackfs.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 54f6e18..5498c4a 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -1497,6 +1497,7 @@ static ssize_t smk_write_access(struct file *file, const char __user *buf,
>  {
>  	struct smack_rule rule;
>  	char *data;
> +	int res;
>  
>  	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
> @@ -1508,8 +1509,10 @@ static ssize_t smk_write_access(struct file *file, const char __user *buf,
>  	if (count < SMK_LOADLEN || smk_parse_rule(data, &rule))
>  		return -EINVAL;
>  
> -	data[0] = smk_access(rule.smk_subject, rule.smk_object,
> -			     rule.smk_access, NULL) == 0;
> +	res = smk_access(rule.smk_subject, rule.smk_object, rule.smk_access,
> +			  NULL);
> +	data[0] = res == 0 ? '1' : '0';
> +	data[1] = '\0';
>  
>  	simple_transaction_set(file, 1);
>  	return SMK_LOADLEN;


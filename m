Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab3AITQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:16:34 -0500
Received: from nm21-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.31]:21191
	"EHLO nm21-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367Ab3AITQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:16:33 -0500
X-Yahoo-Newman-Id: 206296.76035.bm@smtp108.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gaKyc.AVM1mzXTva24LGKjUQm6dsT.DmtauIlwoy.eqAKui
 sGbfqPxHYGZWBUxF9zpRVWSHc1vTLLkvyGm6xh0faXYd4VcHaCxmLajq28zv
 G0ePQ5tN.Z1fvDEtKkPpZ0YJBMbVJbbhTevm.K1.JLfua88i.q72ieGhX0yd
 pobJvTBetBA2DXU0M.j4OrCfMuOMSbstEOR3xXiUwB8XjiAzxPGaEQERMYSO
 p4WQbbm56goce.fbsuIi5En4YxLCRQo_zJFxMLKNNl9V89FXVWMnuTXOtPHm
 4tyutTsMrPYwt2PwHNP6ttFjLW9ap1DyNJby4cgLsYXrblUC.sqGDGbjsW1k
 emw9CifH4qHm0LcPjjEcZH7Q3vfDrHroziCNMYdftcpgFII0S6N2v04uJbfL
 gDgX938AjPuRpLb.DVyBBpM4fLRerEKG9.Hff8r1xz1zlUmDgkM6gxSIIWy9
 6sxHO2ABzEsGf9qBTYKr6.g4eirJFp9UYYJc05uZ0t6UaPqIfeD9dFdLdeGW
 c5SR.BhgSFF8QDYlO2QtWY6NShl8COOQQnSKIKX.xtOdJKl.VN8oUyQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EDC21F.4050404@schaufler-ca.com>
Date: Wed, 09 Jan 2013 11:16:47 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rafal Krypa <r.krypa@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: prevent revoke-subject from failing when unseen
 label is written to it
References: <1354030091-32501-1-git-send-email-r.krypa@samsung.com>
In-Reply-To: <1354030091-32501-1-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 7:28 AM, Rafal Krypa wrote:
> Special file /smack/revoke-subject will silently accept labels that are not
> present on the subject label list. Nothing has to be done for such labels,
> as there are no rules for them to revoke.
>
> Targeted for git://git.gitorious.org/smack-next/kernel.git
>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#stage-for-3.9


> ---
>  security/smack/smackfs.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 76a5dca..337e32c 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -2035,10 +2035,8 @@ static ssize_t smk_write_revoke_subj(struct file *file, const char __user *buf,
>  	}
>  
>  	skp = smk_find_entry(cp);
> -	if (skp == NULL) {
> -		rc = -EINVAL;
> +	if (skp == NULL)
>  		goto free_out;
> -	}
>  
>  	rule_list = &skp->smk_rules;
>  	rule_lock = &skp->smk_rules_lock;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab2GKPUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:20:32 -0400
Received: from nm18-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.23]:41852
	"HELO nm18-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755599Ab2GKPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:20:31 -0400
X-Yahoo-Newman-Id: 589238.54051.bm@smtp107.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4df.mRYVM1nMcMeAEqsJwlFexQQggAtjN98rTFgQbMetTD6
 zgoqV5CkBe1jo7BtFkyGs.BiMrjgeJ3p3Bm.5fLZtnh5uyikwxLBk.5bfLEs
 aMCnGwOcdQcxDGeHbqHV.yo4hBlYfkrH.EHR4iujKFDJSU7Ko1eqrloiAhY_
 h1hbIHKGP6Fxb5ydc6d3XZd9ejVhQ2xaSHsDWZo64zxD.I2C6gm1kmXF42d3
 6y6xeqieqTUf6YjRv4LrClYsCvTIC8f3sZXb2OeTIidDsF57HJMIYci16PSM
 a25G4zenDG2hfOsXh7CxNXIcik.Tn2QOmVmq7ujNFgga6cAhtpgzbBxGJYys
 4.RxYapp32x.PKsLRaAkB_RaNhuvbmRLEQSv3eD6tOLbqF_dkPT5P.iJca5D
 BeovYg4X5dpcRpSJKDB0weBAlS9RMFweRz.JWZG9eSg0ARZWeP9nMI6T8ai_
 9juqv6Hx8QwaXaOpd33yGop9.hojZSkvnWoyzIzffrlqAnDREulgFVljJ4HA
 eHgLBotgkYIxZWKgKpYiuTRLvoAylZ6FIwZc-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FFD99C0.5090200@schaufler-ca.com>
Date: Wed, 11 Jul 2012 08:20:32 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rafal Krypa <r.krypa@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: don't show empty rules when /smack/load or /smack/load2
 is read
References: <1341855394-13359-1-git-send-email-r.krypa@samsung.com>
In-Reply-To: <1341855394-13359-1-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2012 10:36 AM, Rafal Krypa wrote:
> This patch removes empty rules (i.e. with access set to '-') from the
> rule list presented to user space.
>
> Smack by design never removes labels nor rules from its lists. Access
> for a rule may be set to '-' to effectively disable it. Such rules would
> show up in the listing generated when /smack/load or /smack/load2 is
> read. This may cause clutter if many rules were disabled.
>
> As a rule with access set to '-' is equivalent to no rule at all, they
> may be safely hidden from the listing.
>
> Targeted for git://git.gitorious.org/smack-next/kernel.git

Applied to git://git.gitorious.org/smack-next/kernel.git

>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
> ---
>  security/smack/smackfs.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 29b760d..d31e6d9 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -518,6 +518,9 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
>  	if (strlen(srp->smk_subject) >= max || strlen(srp->smk_object) >= max)
>  		return;
>  
> +	if (srp->smk_access == 0)
> +		return;
> +
>  	seq_printf(s, "%s %s", srp->smk_subject, srp->smk_object);
>  
>  	seq_putc(s, ' ');
> @@ -532,8 +535,6 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
>  		seq_putc(s, 'a');
>  	if (srp->smk_access & MAY_TRANSMUTE)
>  		seq_putc(s, 't');
> -	if (srp->smk_access == 0)
> -		seq_putc(s, '-');
>  
>  	seq_putc(s, '\n');
>  }



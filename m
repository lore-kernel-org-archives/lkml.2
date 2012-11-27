Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2K0R3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:29:37 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:39836 "HELO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756639Ab2K0R3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:29:32 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2012 12:29:32 EST
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OSq__pgVM1lG9sFUSjnC3z7IogJUodAxd7xIWaa.V1XSg8L
 hPHOiLY_9LxKcT_xA0FLj8nyUN94mVMW6lHWchiz_DM3oGE6CKLx9.ZskwHJ
 FC16pyJxnMZPeZxW_2NTdqReeZ0IBPcAAeWBcrHEhYXx82YGO_o8jyremQuI
 oMprxx_fXqdFl4cj9Pi2ChaLh2..vLGhUSQQokUc1CtWQRPPFVUGjGGqiWM0
 drvoPRX_xv_LmHioxfX.amHbquKnbs_nB5p.Bmzr_6RcSJ88DIHTbRzxhDyI
 5SCS48qM6HNelC8u4.XR7FptNEeV5mnB5ShHXCCjWkftJ.U_45v9Bu3U3dQ3
 4QtaCU6bgVEf8SEj_4lIepHDImhMnNLUpqdtgFBo6R_gsg2rxAuDvWvKQR7i
 6YBfeu49YQtJAsxi4SeoI5ZYv3efpHnLOdUT3iRtWqvIoF9AMk6zgHKLHXbi
 0jxD95rC71bH.mXBqvzhtfuWiUAkZ4VmTnE2H_3Wl5huQzolfB33nRV2mu9s
 96Zhec_YXyMz0LMTStjOrYAB7eqp55Z1R0d1cJPhOPwqby3Eei_Lp
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50B4F6F1.7020800@schaufler-ca.com>
Date: Tue, 27 Nov 2012 09:22:57 -0800
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

I will queue this for 3.9 as I've just submitted the 3.8 Smack
changes.

>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
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


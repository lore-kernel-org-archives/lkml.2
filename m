Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2K0RaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:30:11 -0500
Received: from smtp109.biz.mail.bf1.yahoo.com ([98.139.244.33]:35894 "HELO
	smtp109.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755959Ab2K0RaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:30:09 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2012 12:30:08 EST
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ASSvk4oVM1kwZTjya7Fu63ZD6EEKCHnlh5kQws5p5cwhc8v
 4TQ8VWsAMp9OPNXONWBZWL0_Qt4G2udTEDyyX8hxLdrDAZK3H2vev6jt489_
 rcJvnz3E7tumUu_RNZYWQPzJNkAQhJqyM1V_mVC7FtjH4y6kLqTtZTiNI0Aa
 m5QIJnAhGfzPfmFJM24sA._pLwOIrqQOdX3c24ZdqUEZUh9VQQWSrm.g7M0b
 0_0sWigab.t7lys5WqqPYjHpiodQn5TE79dDNf.ShtMGQZUkjG4LaScBOW4D
 Jw5QuahtLoUvLI4tGfZ348i3jGKaRApW3Ku5cXWyAcAdWJWF02PESFp2RBFy
 _effFumiZ02RN13EfxTHJrxAAbsEEGdNJH8BVH07t3gbBkd2pA1PfvxuL_ge
 3N2_jLDOAu4CATc1PVcbkurm9p3NWmhPh7SIygT7MWoIRkT8k4MZ9r.gOvrb
 O_HPaQplDejL4l2DusKMSucG6w4tyIp45Ov3vegzIIW2Xirvi.2gJOUP5ZbO
 Cw2aN4BjkDI2MwX5kh9GwLyXJCy1_hnXETagaLSatL1Ee2m0WH4tJ
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50B4F717.4010605@schaufler-ca.com>
Date: Tue, 27 Nov 2012 09:23:35 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rafal Krypa <r.krypa@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: add missing support for transmute bit in smack_str_from_perm()
References: <1354030147-32577-1-git-send-email-r.krypa@samsung.com>
In-Reply-To: <1354030147-32577-1-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 7:29 AM, Rafal Krypa wrote:
> This fixes audit logs for granting or denial of permissions to show
> information about transmute bit.
>
> Targeted for git://git.gitorious.org/smack-next/kernel.git

I will queue this for 3.9 as I've just submitted the 3.8 Smack
changes.

>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
> ---
>  security/smack/smack_access.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index db14689..2e397a8 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -252,6 +252,8 @@ static inline void smack_str_from_perm(char *string, int access)
>  		string[i++] = 'x';
>  	if (access & MAY_APPEND)
>  		string[i++] = 'a';
> +	if (access & MAY_TRANSMUTE)
> +		string[i++] = 't';
>  	string[i] = '\0';
>  }
>  /**


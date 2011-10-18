Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab1JRTH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:07:27 -0400
Received: from nm6-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.158]:34007
	"HELO nm6-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752146Ab1JRTHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:07:25 -0400
X-Yahoo-Newman-Id: 662142.41888.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bEdElfoVM1mPfoD8AdO9bl377VD07j_SBd3bpJdbsPFVzxz
 9JQAa1Se9cG8SCk5kI52Vx58VW.lEDM_BflQkg_5Dxzt5Av8gPaJZo5G9oal
 7vI_mFWiWJclYfrlvgHmxAwmEf85DiFH3NEa3jeIxR6UODyIucWaAx6uJYMl
 kt0XjvxJnHXlvZW06zGJnsenS0AJPNb7_nz4NNPMikmQjYThFfPBCytEkUTb
 OhT9xn3krxe87nherNkbejScrEY82NQoMVn46IRF_umJHcwsutBfuNXG59UE
 CGAokBd9jGd3kxrNN62bjmHr7SFdt2Ycb7FTulpOS3JpFsy_4_f66k52sn6n
 7PAzgUeSs4P1hHcPdVx2kTJYMZ_WGYI4zK8jBMLSXS4r996MN9XTXyLugh46
 IP34HLP09F5MFaTODSAC4Ge37UBzbHFnD7pzzXtNeBoHiNBk66xj31jPlyGk
 ycChvjnXp7rL4GdZLA24iur46CWFH6JzY5YBQP6U8Zw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E9DCE6B.9060006@schaufler-ca.com>
Date: Tue, 18 Oct 2011 12:07:23 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH] Smack: fix: invalid length set for the result of /smack/access
References: <1318937668-3602-1-git-send-email-jarkko.j.sakkinen@gmail.com>
In-Reply-To: <1318937668-3602-1-git-send-email-jarkko.j.sakkinen@gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 4:34 AM, Jarkko Sakkinen wrote:
> Forgot to update simple_transaction_set() to take terminator
> character into account.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>

Applied to git://gitorious.org/smack-next/kernel.git#master
commit d86b2b61d4dea614d6f319772a90a8f98b55ed67


> ---
>  security/smack/smackfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 5498c4a..381eecf 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -1514,7 +1514,7 @@ static ssize_t smk_write_access(struct file *file, const char __user *buf,
>  	data[0] = res == 0 ? '1' : '0';
>  	data[1] = '\0';
>  
> -	simple_transaction_set(file, 1);
> +	simple_transaction_set(file, 2);
>  	return SMK_LOADLEN;
>  }
>  


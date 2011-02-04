Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1BDVJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:09:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44617 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1BDVJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:09:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <1296851935-6909-1-git-send-email-lucian.grijincu@gmail.com>
Date: Fri, 04 Feb 2011 13:09:38 -0800
In-Reply-To: <1296851935-6909-1-git-send-email-lucian.grijincu@gmail.com>
	(Lucian Adrian Grijincu's message of "Fri, 4 Feb 2011 22:38:55 +0200")
Message-ID: <m11v3nik19.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18TYPKx4CmeWJ4oF5YbiUMdZIqxjGjgT3E=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: fix binary sysctl overflow
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> We allocated a vector of CTL_MAXNAME elements and considered
> [0, CTL_MAXNAME] as valid indexes in the vector.
>
> This fixes valid index range to be [0, CTL_MAXNAME).
>
> I guess this should be backported to stable trees too.

No.  This part of the code is correct.  0 is a valid index,
and the array is only CTL_MAXNAME entries long.

I think the maximum depth of this table is only about 6, but
feel free to count and tell me CTL_MAXNAME is set too low.

Eric


>
> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
> ---
>  kernel/sysctl_binary.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index b875bed..e2f377c 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -1446,7 +1446,7 @@ static ssize_t do_sysctl(int __user *args_name, int nlen,
>  	int i;
>  
>  	/* Check args->nlen. */
> -	if (nlen < 0 || nlen > CTL_MAXNAME)
> +	if (nlen < 0 || nlen >= CTL_MAXNAME)
>  		return -ENOTDIR;
>  	/* Read in the sysctl name for simplicity */
>  	for (i = 0; i < nlen; i++)

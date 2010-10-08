Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0JHGa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 02:30:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46850 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0JHGaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 02:30:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: 2.6.36-rc7: kernel panic with SECURITY_TOMOYO=y
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        takedakn@nttdata.co.jp, lists@nerdbynature.de, kawime@gmx.de,
        jkosina@suse.cz, linux-security-module@vger.kernel.org
In-Reply-To: <201010080626.o986QJX4002281@www262.sakura.ne.jp>
References: <20101008134644.8049.A69D9226@jp.fujitsu.com> <201010080626.o986QJX4002281@www262.sakura.ne.jp>
Message-Id: <20101008153001.BCE5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  8 Oct 2010 15:30:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From cc7601c18982909987bbb48971acb86a69a3317a Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Fri, 8 Oct 2010 14:43:22 +0900
> Subject: [PATCH] TOMOYO: Print URL information before panic().
> 
> Configuration files for TOMOYO 2.3 are not compatible with TOMOYO 2.2.
> But current panic() message is too unfriendly and is confusing users.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  security/tomoyo/common.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
> index c668b44..1f0d45a 100644
> --- a/security/tomoyo/common.c
> +++ b/security/tomoyo/common.c
> @@ -2051,13 +2051,22 @@ void tomoyo_check_profile(void)
>  		const u8 profile = domain->profile;
>  		if (tomoyo_profile_ptr[profile])
>  			continue;
> +		printk(KERN_ERR "You need to define profile %u before using it.\n",
> +		       profile);
> +		printk(KERN_ERR "Please see http://tomoyo.sourceforge.jp/2.3/ "
> +		       "for more information.\n");
>  		panic("Profile %u (used by '%s') not defined.\n",
>  		      profile, domain->domainname->name);
>  	}
>  	tomoyo_read_unlock(idx);
> -	if (tomoyo_profile_version != 20090903)
> +	if (tomoyo_profile_version != 20090903) {
> +		printk(KERN_ERR "You need to install userland programs for "
> +		       "TOMOYO 2.3 and initialize policy configuration.\n");
> +		printk(KERN_ERR "Please see http://tomoyo.sourceforge.jp/2.3/ "
> +		       "for more information.\n");
>  		panic("Profile version %u is not supported.\n",
>  		      tomoyo_profile_version);
> +	}
>  	printk(KERN_INFO "TOMOYO: 2.3.0\n");
>  	printk(KERN_INFO "Mandatory Access Control activated.\n");
>  }
> -- 
> 1.7.1


Looks good to me. thanks.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



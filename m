Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0KJSYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:24:21 -0500
Received: from mail.perches.com ([173.55.12.10]:4933 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0KJSYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:24:19 -0500
Subject: Re: [PATCH v3] msm: smd: Reduce driver log chatter
From: Joe Perches <joe@perches.com>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1289411969-24650-1-git-send-email-davidb@codeaurora.org>
References: <1289349036-16941-1-git-send-email-davidb@codeaurora.org>
	 <1289411969-24650-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 10:24:17 -0800
Message-ID: <1289413457.15905.95.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 09:59 -0800, David Brown wrote:
>  arch/arm/mach-msm/smd.c |   18 ++++++++++--------

Hi again David.  More trivia. Ignore at your pleasure.

>  1 files changed, 10 insertions(+), 8 deletions(-)
> diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c

A moderately common kernel style uses macros like:

#define FUNC_ENTER()	pr_debug("--> %s\n", __func__);
#define FUNC_EXIT()	pr_debug("<-- %s\n", __func__);
or
#define FUNC_ENTER()	pr_debug("Enter %s\n", __func__);
#define FUNC_EXIT()	pr_debug("Exit  %s\n", __func__);

The macro names vary.
I've seen enter, _enter, kenter, func_enter, etc.

> @@ -939,7 +941,7 @@ int smsm_set_sleep_duration(uint32_t delay)
>  int smd_core_init(void)
>  {
>  	int r;
> -	pr_info("smd_core_init()\n");
> +	pr_debug("smd_core_init()\n");

	FUNC_ENTER();

> @@ -992,14 +994,14 @@ int smd_core_init(void)
>  	smsm_change_state(SMSM_STATE_APPS_DEM, ~0, 0);
>  #endif
>  
> -	pr_info("smd_core_init() done\n");
> +	pr_debug("smd_core_init() done\n");

	FUNC_EXIT();

>  static int __devinit msm_smd_probe(struct platform_device *pdev)
>  {
> -	pr_info("smd_init()\n");
> +	pr_debug("smd_init()\n");

wrong function name? FUNC_ENTER();


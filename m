Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1DVWM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:12:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45241 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab1DVWMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:12:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] pm / core bugfix: report error return from suspend_enter
Date: Sat, 23 Apr 2011 00:13:27 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
References: <1303456931-11657-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1303456931-11657-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201104230013.27359.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 22, 2011, MyungJoo Ham wrote:
> The current implementation of suspend-to-RAM returns 0 if there is an
> error from suspend_enter() because suspend_devices_and_enter() ignores
> the return value from suspend_enter(). This patch addresses this issue
> and properly keep the error return from suspend_enter() and let
> suspend_devices_and_enter relay the error return.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> ---
>  kernel/power/suspend.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 2814c32..08515b4 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -224,7 +224,7 @@ int suspend_devices_and_enter(suspend_state_t state)
>  	if (suspend_test(TEST_DEVICES))
>  		goto Recover_platform;
>  
> -	suspend_enter(state);
> +	error = suspend_enter(state);
>  
>   Resume_devices:
>  	suspend_test_start();
> 


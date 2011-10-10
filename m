Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1JJVoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:44:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60006 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab1JJVoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:44:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tom.leiming@gmail.com
Subject: Re: [RESEND PATCH 1/2] PM/runtime: update document about callbacks
Date: Mon, 10 Oct 2011 23:46:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
References: <1318131626-9373-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1318131626-9373-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110102346.17304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 09, 2011, tom.leiming@gmail.com wrote:
> From: Ming Lei <ming.lei@canonical.com>
> 
> Support for device power domains has been introduced in
> commit 9659cc0678b954f187290c6e8b247a673c5d37e1 (PM: Make
> system-wide PM and runtime PM treat subsystems consistently),
> also power domain callbacks will take precedence over subsystem ones
> from commit 4d27e9dcff00a6425d779b065ec8892e4f391661(PM: Make
> power domain callbacks take precedence over subsystem ones).
> 
> So update part of "Device Runtime PM Callbacks" in
> Documentation/power/runtime_pm.txt.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Applied to linux-pm/pm-runtime (and merged into linux-pm/linux-next).

Thanks,
Rafael


> ---
>  Documentation/power/runtime_pm.txt |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
> index 1f05404..0e85608 100644
> --- a/Documentation/power/runtime_pm.txt
> +++ b/Documentation/power/runtime_pm.txt
> @@ -43,13 +43,18 @@ struct dev_pm_ops {
>  	...
>  };
>  
> -The ->runtime_suspend(), ->runtime_resume() and ->runtime_idle() callbacks are
> -executed by the PM core for either the device type, or the class (if the device
> -type's struct dev_pm_ops object does not exist), or the bus type (if the
> -device type's and class' struct dev_pm_ops objects do not exist) of the given
> -device (this allows device types to override callbacks provided by bus types or
> -classes if necessary).  The bus type, device type and class callbacks are
> -referred to as subsystem-level callbacks in what follows.
> +The ->runtime_suspend(), ->runtime_resume() and ->runtime_idle() callbacks
> +are executed by the PM core for either the power domain, or the device type
> +(if the device power domain's struct dev_pm_ops does not exist), or the class
> +(if the device power domain's and type's struct dev_pm_ops object does not
> +exist), or the bus type (if the device power domain's, type's and class'
> +struct dev_pm_ops objects do not exist) of the given device, so the priority
> +order of callbacks from high to low is that power domain callbacks, device
> +type callbacks, class callbacks and bus type callbacks, and the high priority
> +one will take precedence over low priority one. The bus type, device type and
> +class callbacks are referred to as subsystem-level callbacks in what follows,
> +and generally speaking, the power domain callbacks are used for representing
> +power domains within a SoC.
>  
>  By default, the callbacks are always invoked in process context with interrupts
>  enabled.  However, subsystems can use the pm_runtime_irq_safe() helper function
> 


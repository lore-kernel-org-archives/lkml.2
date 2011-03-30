Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab1C3VE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:04:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab1C3VE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:04:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Xiaotian Feng <dfeng@redhat.com>
Subject: Re: [PATCH] x86, microcode: unregister syscore_ops after microcode unloaded
Date: Wed, 30 Mar 2011 23:04:23 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1301387672-23661-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1301387672-23661-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103302304.24116.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 29, 2011, Xiaotian Feng wrote:
> Currently, microcode doesn't unregister syscore_ops after it's unloaded.
> So if we modprobe then rmmod microcode, the stale microcode syscore_ops info
> will stay on syscore_ops_list. Later when we're trying to reboot/halt/shutdown
> the machine, kernel will panic on syscore_shutdown(). With the patch
> applied, I can reboot/halt/shutdown my machine successfully.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  arch/x86/kernel/microcode_core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index 5ed0ab5..f924280 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -550,6 +550,7 @@ static void __exit microcode_exit(void)
>  	microcode_dev_exit();
>  
>  	unregister_hotcpu_notifier(&mc_cpu_notifier);
> +	unregister_syscore_ops(&mc_syscore_ops);
>  
>  	get_online_cpus();
>  	mutex_lock(&microcode_mutex);
> 


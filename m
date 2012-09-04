Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2IDWg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:36:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab2IDWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:36:26 -0400
Date: Tue, 4 Sep 2012 15:36:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] kernel/sys.c: call disable_nonboot_cpus in
 kernel_restart
Message-Id: <20120904153624.d4aaed4e.akpm@linux-foundation.org>
In-Reply-To: <1346682298-13958-1-git-send-email-shawn.guo@linaro.org>
References: <1346682298-13958-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Sep 2012 22:24:58 +0800
Shawn Guo <shawn.guo@linaro.org> wrote:

> Like kernel_power_off calls disable_nonboot_cpus, we may want to have
> kernel_restart call disable_nonboot_cpus as well.  Doing so can help
> the machines that require boot cpu be the last alive cpu during reboot
> to survive with kernel restart.

That does sound logical.  But the changelog is very vague and fluffy. 
Does this patch actually fix any known problem on any known machine?

> ...
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -368,6 +368,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
>  void kernel_restart(char *cmd)
>  {
>  	kernel_restart_prepare(cmd);
> +	disable_nonboot_cpus();
>  	if (!cmd)
>  		printk(KERN_EMERG "Restarting system.\n");
>  	else


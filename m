Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976Ab0JGCXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 22:23:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:49777 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757596Ab0JGCXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 22:23:42 -0400
Date: Wed, 6 Oct 2010 19:19:59 -0700
From: Greg KH <gregkh@suse.de>
To: Sameer Nanda <snanda@chromium.org>
Cc: lenb@kernel.org, stefan.bader@canonical.com, brad.figg@canonical.com,
        apw@canonical.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Read TSC upon resume
Message-ID: <20101007021959.GA7300@suse.de>
References: <1286406919-6236-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286406919-6236-1-git-send-email-snanda@chromium.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 04:15:19PM -0700, Sameer Nanda wrote:
> Read the TSC upon resuming and print it out. This is useful
> in helping figure out amount of time spent in the BIOS when
> resuming from suspend.
> 
> Change-Id: I1d6a32bd62421becddecd152d561763e5f3e1101

What is this tag for?  I don't think it matches anything the kernel
community wants, do you?

And are you always going to be printing this out?  Why do we want to
know this every time?


> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> ---
>  drivers/acpi/sleep.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index c0fed2e..f0588fa 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -214,6 +214,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
>  	acpi_status status = AE_OK;
>  	unsigned long flags = 0;
>  	u32 acpi_state = acpi_target_sleep_state;
> +	u64 tsc;
>  
>  	ACPI_FLUSH_CPU_CACHE();
>  
> @@ -235,6 +236,9 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
>  
>  	case ACPI_STATE_S3:
>  		do_suspend_lowlevel();
> +		rdtscll(tsc);
> +		printk(KERN_INFO "TSC at resume: %llu\n",
> +				(unsigned long long)tsc);

How long does this take, will it slow down resume?

thanks,

greg k-h

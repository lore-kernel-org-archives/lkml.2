Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0DUOEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:04:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0DUOEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:04:31 -0400
Subject: Re: [PATCH] trivial: make mmap_min_addr perms 600
From: Eric Paris <eparis@redhat.com>
To: Kyle McMartin <kmcmartin@redhat.com>
Cc: kees@canonical.com, cebbert@redhat.com, linux-kernel@vger.kernel.org,
       jmorris@namei.org
In-Reply-To: <20100421140033.GA8389@ihatethathostname.lab.bos.redhat.com>
References: <20100421140033.GA8389@ihatethathostname.lab.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 10:04:27 -0400
Message-ID: <1271858667.2899.10.camel@dhcp235-240.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 10:00 -0400, Kyle McMartin wrote:
> Chuck points out that mmap_min_addr is 644...
> 
> CAP_SYS_RAWIO will deny users read/write to the file, let's let them see
> that this is intended.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

I'm fine with it.  RAWIO was only really added to block writes as I
recall, but I don't see a good reason normal users need to see this and
blocking them with rwx perms first is a good idea.

Acked-by: Eric Paris <eparis@redhat.com>

James, do you want to pick up and push towards linus?

-Eric
> ---
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 8686b0f..5868481 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1209,7 +1209,7 @@ static struct ctl_table vm_table[] = {
>  		.procname	= "mmap_min_addr",
>  		.data		= &dac_mmap_min_addr,
>  		.maxlen		= sizeof(unsigned long),
> -		.mode		= 0644,
> +		.mode		= 0600,
>  		.proc_handler	= mmap_min_addr_handler,
>  	},
>  #endif



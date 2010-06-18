Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0FRThS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:37:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab0FRThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:37:15 -0400
Subject: Re: [PATCH 5/5]scsi:hosts.c Fix warning: variable 'rval' set but
 not used
From: James Bottomley <James.Bottomley@suse.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <4C1A4A69.7060801@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	 <1276666434-11227-6-git-send-email-justinmattock@gmail.com>
	 <1276702443.2847.153.camel@mulgrave.site>  <4C18F524.4000902@gmail.com>
	 <1276709590.2847.176.camel@mulgrave.site>  <4C1A4A69.7060801@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 14:37:07 -0500
Message-ID: <1276889827.2850.331.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 09:16 -0700, Justin P. Mattock wrote:
> > Erm, well, as I said, error code and the fact that the thread failed to
> > start, so more
> >
> > printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error
> > = %d\n", host->host_no, PTR_ERR(shost->ehandler));
> >
> > James
> >
> 
> o.k. I looked at this a bit more and finally got the thing to build 
> through without a warning, using what you had sent, but keep in mind I 
> still need to add error  = %d\n", host->host_no, to the printk
> 
> here's what I have so far:
> 
> 
>   drivers/scsi/hosts.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 6660fa9..c1ff708 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -419,8 +419,9 @@ struct Scsi_Host *scsi_host_alloc(struct 
> scsi_host_template *sht, int privsize)
> 
>   	shost->ehandler = kthread_run(scsi_error_handler, shost,
>   			"scsi_eh_%d", shost->host_no);
> +	rval = PTR_ERR(shost->ehandler);
>   	if (IS_ERR(shost->ehandler)) {
> -		rval = PTR_ERR(shost->ehandler);
> +		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn\n", 
> rval);

So this isn't really an improvement over the suggestion.  What you
wanted was shost->host_no, as you deduced, but the %d becomes %ld to
quiet the type warning.

James





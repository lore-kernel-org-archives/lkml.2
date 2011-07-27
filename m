Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1G0D0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:26:48 -0400
Received: from sr-smtp.usish.com ([210.5.144.203]:55919 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1G0D0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:26:46 -0400
From: "Jack Wang" <jack_wang@usish.com>
To: "'Luben Tuikov'" <ltuikov@yahoo.com>,
        "'James Bottomley'" <James.Bottomley@suse.de>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
References: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
Date: Wed, 27 Jul 2011 11:26:25 +0800
Message-ID: <3B54164438364A3A9A2F19AFF5A4DF0A@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcxMC05dMN/nxn7zT+WPJGUGSjlBMAAAP6+g
In-Reply-To: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [PATCH] [SCSI] libsas: remove expander from dev list on error
> 
> If expander discovery fails (sas_discover_expander()),
> remove the expander from the port device list
> (sas_ex_discover_expander()), before freeing it. Else
> the list is corrupted and, e.g., when we attempt to send
> SMP commands to other devices, the kernel oopses.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/scsi/libsas/sas_expander.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index 874e29d..f84084b 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expander(
> 
>      res = sas_discover_expander(child);
>      if (res) {
> +        spin_lock_irq(&parent->port->dev_list_lock);
> +        list_del(&child->dev_list_node);
> +        spin_unlock_irq(&parent->port->dev_list_lock);
>          kfree(child);
>          return NULL;
>      }
> --
[Jack Wang] Looks reasonable, thanks for fix this.
You can add my Reviewed-by: Jack Wang <jack_wang@usish.com> if needed.


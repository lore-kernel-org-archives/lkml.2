Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab2HPQcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:32:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53444 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933025Ab2HPQcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:32:52 -0400
Date: Thu, 16 Aug 2012 12:32:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: Hans de Goede <hdegoede@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
In-Reply-To: <87obmals06.fsf@tucsk.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.1208161232001.31195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Miklos Szeredi wrote:

> Yes, this appears to work.  Following patch fixes the suspend oops.
> 
> Thanks,
> Miklos
> 
> ---
>  drivers/ide/ide-pm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
> index 9240609..8d1e32d 100644
> --- a/drivers/ide/ide-pm.c
> +++ b/drivers/ide/ide-pm.c
> @@ -4,7 +4,7 @@
>  
>  int generic_ide_suspend(struct device *dev, pm_message_t mesg)
>  {
> -	ide_drive_t *drive = dev_get_drvdata(dev);
> +	ide_drive_t *drive = to_ide_device(dev);
>  	ide_drive_t *pair = ide_get_pair_dev(drive);
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct request *rq;
> @@ -40,7 +40,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
>  
>  int generic_ide_resume(struct device *dev)
>  {
> -	ide_drive_t *drive = dev_get_drvdata(dev);
> +	ide_drive_t *drive = to_ide_device(dev);
>  	ide_drive_t *pair = ide_get_pair_dev(drive);
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct request *rq;

And now you can get rid of the useless dev_set_drvdata() call.

Alan Stern


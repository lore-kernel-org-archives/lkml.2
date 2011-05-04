Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1EDQCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:02:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51072 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750993Ab1EDQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:02:04 -0400
Date: Wed, 4 May 2011 12:02:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Maxin John <maxin.john@gmail.com>
cc: Michal Nazarewicz <mina86@mina86.com>, <gregkh@suse.de>,
        <m-sonasath@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <roger.quadros@nokia.com>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which
 is always true
In-Reply-To: <BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1105041201120.2039-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Maxin John wrote:

> Hi Michal,
> 
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> Thank you very much for reviewing the patch.
> 
> > file_storage.c has the same check, could you remove it as well.
> 
> Please find the patch for "file_storage.c" below. Should I merge these
> two patches and re-submit as a single one?
> 
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

> ---
> diff --git a/drivers/usb/gadget/file_storage.c
> b/drivers/usb/gadget/file_storage.c
> index a6eacb5..a9c5177 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -2314,7 +2314,7 @@ static int check_command(struct fsg_dev *fsg,
> int cmnd_size,
>                 fsg->lun = lun;         // Use LUN from the command
> 
>         /* Check the LUN */
> -       if (fsg->lun >= 0 && fsg->lun < fsg->nluns) {
> +       if (fsg->lun < fsg->nluns) {
>                 fsg->curlun = curlun = &fsg->luns[fsg->lun];
>                 if (fsg->cmnd[0] != REQUEST_SENSE) {
>                         curlun->sense_data = SS_NO_SENSE;


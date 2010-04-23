Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0DWOXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:23:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37579 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753274Ab0DWOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:23:35 -0400
Date: Fri, 23 Apr 2010 10:23:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: fabien.chouteau@gmail.com
cc: linux-usb@vger.kernel.org, Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Peter Korsgaard <jacmet@sunsite.dk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 2/2] Mass storage gadget: Handle eject request
In-Reply-To: <1272025288-32555-2-git-send-email-fabien.chouteau@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004231020300.1777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 fabien.chouteau@gmail.com wrote:

> From: Fabien Chouteau <fabien.chouteau@barco.com>
> 
> This patch adds handling of the "Start/Stop Unit" SCSI request to simulate media
> ejection. A sysfs entry to get the "eject" state of a LUN is also added.

Sorry I didn't notice this earlier...

> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -163,6 +163,13 @@
>   * ro setting are not allowed when the medium is loaded or if CD-ROM
>   * emulation is being used.
>   *
> + * When a LUN receive an "eject" SCSI request (Start/Stop Unit),
> + * if the LUN is removable, the backing file is released to simulate
> + * ejection.
> + * The "eject" state of a LUN is available in the "ejected" file of the
> + * LUN's sysfs directory (see above). The "eject" state is only updated
> + * by SCSI request, not by user ejection.

What's the reason for that?  With a real removable device, like a CD 
player, it doesn't make any difference whether the medium was ejected 
because of a SCSI command or because I pressed the "eject" button.

I just don't see any point in keeping track of the two actions 
separately, since they end up having the same final result.

Alan Stern


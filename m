Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030601Ab2B2AoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:44:13 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36486 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965840Ab2B2AoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:44:11 -0500
Date: Wed, 29 Feb 2012 04:44:03 +0400
From: Igor Murzov <intergalactic.anonymous@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Murzov <e-mail@date.by>, "Sergey V." <sftp.mtuci@gmail.com>
Subject: Re: [PATCH 1/2] ACPI video: Harden video bus adding.
Message-ID: <20120229044403.56e07c88@garik>
In-Reply-To: <20120229001258.GA10606@core.coreip.homeip.net>
References: <20120229035142.31016e6f@garik>
	<20120229001258.GA10606@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.4; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 16:12:59 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Igor,
> 
> On Wed, Feb 29, 2012 at 03:51:42AM +0400, Igor Murzov wrote:
> > From 127b9fc18ee646d92039c45d7fa3680a107928a2 Mon Sep 17 00:00:00 2001
> > From: Igor Murzov <e-mail@date.by>
> > Date: Mon, 27 Feb 2012 21:50:17 +0400
> > Subject: [PATCH 1/2] ACPI video: Harden video bus adding.
> > 
> > It is always better to check return values.
> > 
> > Signed-off-by: Igor Murzov <e-mail@date.by>
> > ---
> >  drivers/acpi/video.c |   28 +++++++++++++++++++---------
> >  1 files changed, 19 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> > index eaef02a..1bc6370 100644
> > --- a/drivers/acpi/video.c
> > +++ b/drivers/acpi/video.c
> > @@ -548,24 +548,25 @@ acpi_video_device_EDID(struct acpi_video_device *device,
> >   *		1. 	The system BIOS should NOT automatically control the brightness 
> >   *			level of the LCD when the power changes from AC to DC.
> >   * Return Value:
> > - * 		-1	wrong arg.
> > + * 		-EINVAL	wrong arg.
> >   */
> >  
> >  static int
> >  acpi_video_bus_DOS(struct acpi_video_bus *video, int bios_flag, int lcd_flag)
> >  {
> > -	u64 status = 0;
> > +	int status = 0;
> >  	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
> >  	struct acpi_object_list args = { 1, &arg0 };
> >  
> >  
> >  	if (bios_flag < 0 || bios_flag > 3 || lcd_flag < 0 || lcd_flag > 1) {
> > -		status = -1;
> > +		status = -EINVAL;
> >  		goto Failed;
> >  	}
> >  	arg0.integer.value = (lcd_flag << 2) | bios_flag;
> >  	video->dos_setting = arg0.integer.value;
> > -	acpi_evaluate_object(video->device->handle, "_DOS", &args, NULL);
> > +	status = acpi_evaluate_object(video->device->handle, "_DOS",
> > +	                              &args, NULL);
> 
> Here (as well as in the rest of your patch) you are mixing up errors
> from the standard Unix -E* namespace and ACPI AE_* namespace. You need
> to settle on one and be consistent (and also make sure that upper layers
> get wha they expect, namely -E* namespace).

Thanks for the reply. Will fix this and resend.


-- Igor

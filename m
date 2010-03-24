Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0CXJSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:18:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0CXJSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:18:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve Cave <steve.cave@ntlworld.com>
Subject: Re: Linux kernel patch
Date: Wed, 24 Mar 2010 10:17:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, wfp5p@virginia.edu, m.kozlowski@tuxland.pl, julia@diku.dk,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <201003232252.35958.steve.cave@ntlworld.com>
In-Reply-To: <201003232252.35958.steve.cave@ntlworld.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003241017.54346.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+mO+KafyUB3EtmiFJnOkiZUJ8foNpKU1Jgy2F
 wmNNCDHxYYZXwoRhbMJ7NLFqyYMu2jqFQv5va879ciDvoEnspm
 q2YG2cTkAFLZyQa6VSRdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Steve Cave wrote:
> Please find enclosed a patch (my first) to fix checkpatch.pl issues with the
>  usbduxfast.c in the comedi driver. Please note that there is one outstanding
> issue, with semaphores and mutex, that I do not feel qualified to patch.

Hi Steve,

Thanks for your contribution. Since this is your first patch, let me go
through it in detail and comment on all issues. Many of these are details
that might otherwise get ignored, but getting this right will help you
get future patches accepted faster.

First of all, the email subject line and introduction above is misplaced.
The subject should be the line you have below, as it comes from
git-format-patch. Try using git-send-email to send that file to yourself
to see what it should look like.

Your description above could have gone below the '---' line, which is
the part that does not get merged into the changelog.

> ---
> From 93c6eae8685fe87c4796e5e177ea136a155bfe2f Mon Sep 17 00:00:00 
> 2001

This looks like it got linewrapped, indicating that you are using a broken
email client. See Documentation/email-clients.txt for more information
on this.

Further, this line is not generally put into a submission, just leave it out.

> From: Steve Cave <steve.cave@ntlworld.com>
> Date: Wed, 17 Mar 2010 20:58:35 +0000
> Subject: [PATCH] Staging: comedi: fix line lengths and indentation in 
> usbduxfast.c
> 
> This is a patch to the usbduxfast.c file that reformats and breaks up a
> number of code lines greater than 80 characters long, standardizing
> indents and replacing some spaces with tabs to fix warnings found by the
> checkpatch tool; also replacing a foo * bar with foo *bar to fix an error
> found by checkpatch

This description is mostly ok. It's probably better to leave out the
redundant 'This is a patch to the usbduxfast.c file' part, which is
totally obvious.

Note that this kind of patch is good and welcome for staging drivers,
but please don't send reformatting patches for stuff outside of
staging. Even for staging, I'd encourage you to read up on topics like
the semaphore to mutex conversion, because changes that really improve
the code are generally appreciated more than those that just change
formatting.

Ideally, you should follow the rule to only send formatting patches
when you also have real code changes for the same files in the same
series (never mix the two in the same patch though). For some new staging
drivers, doing just the formatting can often help as well, but
comedi has probably moved beyond that stage.

> @@ -271,7 +271,8 @@ static int usbduxfast_ai_stop(struct 
> usbduxfastsub_s *udfs, int do_unlink)
>  	udfs->ai_cmd_running = 0;
>  
>  	if (do_unlink)
> -		ret = usbduxfastsub_unlink_InURBs(udfs);	/* stop aquistion */
> +		ret = usbduxfastsub_unlink_InURBs(udfs);
> +						/* stop acquistion */
>  
>  	return ret;
>  }

The comment now looks misplaced IMHO, it may be better to put it into the
line before the ret = .

> @@ -451,13 +452,14 @@ static int usbduxfastsub_start(struct 
> usbduxfastsub_s *udfs)
>  
>  	/* 7f92 to zero */
>  	local_transfer_buffer[0] = 0;
> -	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
> 0), USBDUXFASTSUB_FIRMWARE,	/* bRequest, "Firmware" */
> -			      VENDOR_DIR_OUT,	/* bmRequestType */
> -			      USBDUXFASTSUB_CPUCS,	/* Value */
> -			      0x0000,	/* Index */
> -			      local_transfer_buffer,	/* address of the transfer buffer 
> */
> -			      1,	/* Length */
> -			      EZTIMEOUT);	/* Timeout */
> +	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
> 0),
> +			USBDUXFASTSUB_FIRMWARE,	/* bRequest, 
> "Firmware" */
> +			VENDOR_DIR_OUT,	/* bmRequestType */
> +			USBDUXFASTSUB_CPUCS,	/* Value */
> +			0x0000,	/* Index */
> +			local_transfer_buffer,	/* transfer buffer address  */
> +			1,	/* Length */
> +			EZTIMEOUT);	/* Timeout */
>  	if (ret < 0) {
>  		printk("comedi_: usbduxfast_: control msg failed (start)\n");
>  		return ret;

This one is not really an improvement. The arguments are aligned with the
opening braces already, so you should leave that. In this case, it may actually
be better to remove some or all of the comments in this call in order to
improve readability. Often (but not in this particular case), you can
fix code like this by moving parts into a separate function.

> @@ -473,12 +475,13 @@ static int usbduxfastsub_stop(struct 
> usbduxfastsub_s *udfs)
>  
>  	/* 7f92 to one */
>  	local_transfer_buffer[0] = 1;
> -	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
> 0), USBDUXFASTSUB_FIRMWARE,	/* bRequest, "Firmware" */
> -			      VENDOR_DIR_OUT,	/* bmRequestType */
> -			      USBDUXFASTSUB_CPUCS,	/* Value */
> -			      0x0000,	/* Index */
> -			      local_transfer_buffer, 1,	/* Length */
> -			      EZTIMEOUT);	/* Timeout */
> +	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
> 0),
> +			USBDUXFASTSUB_FIRMWARE,	/* bRequest, 
> "Firmware" */
> +			VENDOR_DIR_OUT,	/* bmRequestType */
> +			USBDUXFASTSUB_CPUCS,	/* Value */
> +			0x0000,	/* Index */
> +			local_transfer_buffer, 1,	/* Length */
> +			EZTIMEOUT);	/* Timeout */
>  	if (ret < 0) {
>  		printk(KERN_ERR "comedi_: usbduxfast: control msg failed "
>  		       "(stop)\n");

same as above.

> @@ -1347,7 +1351,7 @@ static int usbduxfast_ai_insn_read(struct 
> comedi_device *dev,
>  #define FIRMWARE_MAX_LEN 0x2000
>  
>  static int firmwareUpload(struct usbduxfastsub_s *usbduxfastsub,
> -			  const u8 * firmwareBinary, int sizeFirmware)
> +			  const u8 *firmwareBinary, int sizeFirmware)
>  {
>  	int ret;
>  	uint8_t *fwBuf;

ok

> @@ -1357,7 +1361,7 @@ static int firmwareUpload(struct usbduxfastsub_s 
> *usbduxfastsub,
>  
>  	if (sizeFirmware > FIRMWARE_MAX_LEN) {
>  		dev_err(&usbduxfastsub->interface->dev,
> -			"comedi_: usbduxfast firmware binary it too large for FX2.
> \n");
> +		"comedi_: usbduxfast firmware binary too large for FX2.\n");
>  		return -ENOMEM;
>  	}
  
The original was better here, you should never align function arguments with the
function name itself. You can split up overly long lines like

			"comedi_: usbduxfast firmware binary too large "
			"for FX2.\n"

but in this case, it's probably better to go over the 80 columns. It's really
not such a hard rule.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0HXPts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:49:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:56605 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab0HXPtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:49:46 -0400
Date: Tue, 24 Aug 2010 17:49:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usbhid: Set Report ID properly for Output reports
 on the Control endpoint.
In-Reply-To: <1282020244-25786-1-git-send-email-alan@signal11.us>
Message-ID: <alpine.LNX.2.00.1008241747570.1019@pobox.suse.cz>
References: <1282020244-25786-1-git-send-email-alan@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Alan Ott wrote:

> When I made commit 29129a98e6fc89, I didn't account for *buf not being
> the report ID anymore, as buf is incremented.
> 
> This applies to 2.6.35 and newer.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  drivers/hid/usbhid/hid-core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index b729c02..ffd6899 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -828,6 +828,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
>  		}
>  	} else {
>  		int skipped_report_id = 0;
> +		int report_id = buf[0];
>  		if (buf[0] == 0x0) {
>  			/* Don't send the Report ID */
>  			buf++;
> @@ -837,7 +838,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
>  		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
>  			HID_REQ_SET_REPORT,
>  			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> -			((report_type + 1) << 8) | *buf,
> +			((report_type + 1) << 8) | report_id,
>  			interface->desc.bInterfaceNumber, buf, count,
>  			USB_CTRL_SET_TIMEOUT);
>  		/* count also the report id, if this was a numbered report. */

Good catch, applied, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab1EIK4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:56:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44305 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1EIK4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=NFRnJLYWe5zE6M6ap4rdS91hbsRkffxRof6gc9pIw37kSEmDv7GK19q3/e9MK1KhTO
         5Onc3W4Zc+oilgzG8tunVTVBm4IEn4k44lCbK7mHB/e2lBPCsGYAOHjKR6JM9l7gNGkr
         1kqVmS2d5qysd29+ssi40VDX4RCTruKHbMVmU=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: stern@rowland.harvard.edu, m-sonasath@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] usb: gadget: f_mass_storage: Make us pass USBCV
 MSC Compliance tests
References: <1304935687-5428-1-git-send-email-roger.quadros@nokia.com>
 <1304935687-5428-3-git-send-email-roger.quadros@nokia.com>
Date: Mon, 09 May 2011 12:56:13 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vu7nbzdb3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1304935687-5428-3-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 May 2011 12:08:07 +0200, Roger Quadros wrote:
> Defer the SET_CONFIG and SET_INTERFACE control transfer's data/status
> stages till we are ready to process new CBW from the host. This way we
> ensure that we don't loose any CBW during MSC compliance tests and cause
> lock up.
>
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> @@ -2468,7 +2469,7 @@ static int fsg_set_alt(struct usb_function *f,  
> unsigned intf, unsigned alt)
>  	struct fsg_dev *fsg = fsg_from_func(f);
>  	fsg->common->new_fsg = fsg;
>  	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
> -	return 0;
> +	return USB_GADGET_DELAYED_STATUS;
>  }
> static void fsg_disable(struct usb_function *f)

Just a side note, an idea that came to my mind: How about instead
of creating meaning of an arbitrary return value, creating a
usb_composite_setup_pause() or usb_composite_setup_delay()
function?  It would be more symmetrical that way.  Just an idea,
feel free to ignore.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--

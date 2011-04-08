Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab1DHDbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 23:31:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53076 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab1DHDbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 23:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=i34qzoQ4kihaJSg7F6bGOvv/iDgeIRY1bhwYZbPdu2HCondEwTa+SNCY9kB/HG6/kS
         WEo3dyvIsJh+iyCoJ8FHuZc4CGjWJHx6wovYonw2JWhbcc77a1BvFUfA4NWHkZsxhIwn
         SZFWQ+optH3xeGC8LAS36mY5TwBQqs+1Y4IjQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTik5VGziYQLQTzMDhYD7CA0QpSNK6g@mail.gmail.com>
References: <BANLkTim8anqNv4MEaxCTyC8HyOZp2x=ixQ@mail.gmail.com>
 <20110407163948.GD31060@kroah.com> <BANLkTikUrdte93L=3Nq3TXYMpeqRJfj2YQ@mail.gmail.com>
 <BANLkTik5VGziYQLQTzMDhYD7CA0QpSNK6g@mail.gmail.com>
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Fri, 8 Apr 2011 05:31:20 +0200
Message-ID: <BANLkTik4W7+1YY+dkP4NrQZ7J3e0crmXbg@mail.gmail.com>
Subject: Re: [Regression] USB tethering does not work anymore in 2.6.29-rc2
 (rndis_host, does not receive DHCP offer anymore)
To: huajun li <huajun.li.lee@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-net@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   I found the new added mask code 'FLAG_POINTTOPOINT' overlapped
> 'FLAG_MULTI_PACKET' in    include/linux/usb/usbnet.h, this maybe
> caused logic issue in rx_process(). I create a patch for this, but
> have no such a device to test it, could you have a try? thanks.

Will try the patch tomorrow morning and report back.

Gottfried


> [PATCH]    Clean up mask code overlaps in driver_info of usbnet
>
> Signed-off-by:  Huajun Li <huajun.li.lee@gmail.com>
> ---
>  include/linux/usb/usbnet.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> index 3c7329b..0e18550 100644
> --- a/include/linux/usb/usbnet.h
> +++ b/include/linux/usb/usbnet.h
> @@ -103,8 +103,8 @@ struct driver_info {
>  * Indicates to usbnet, that USB driver accumulates multiple IP packets.
>  * Affects statistic (counters) and short packet handling.
>  */
> -#define FLAG_MULTI_PACKET      0x1000
> -#define FLAG_RX_ASSEMBLE       0x2000  /* rx packets may span >1 frames */
> +#define FLAG_MULTI_PACKET      0x2000
> +#define FLAG_RX_ASSEMBLE       0x4000  /* rx packets may span >1 frames */
>
>        /* init device ... can sleep, or cause probe() failure */
>        int     (*bind)(struct usbnet *, struct usb_interface *);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2AXMjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:39:19 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:38510 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2AXMjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:39:17 -0500
From: Oliver Neukum <oliver@neukum.org>
To: ondra.havel@gmail.com
Subject: Re: [PATCH v2] input: Hanvon Art Master I and Rollick tablet support (USB)
Date: Tue, 24 Jan 2012 13:41:10 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <alpine.LRH.2.00.1201230211440.12906@linux.fjfi.cvut.cz>
In-Reply-To: <alpine.LRH.2.00.1201230211440.12906@linux.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201241341.10614.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 23. Januar 2012, 02:22:07 schrieb ondra.havel@gmail.com:
> +static void hanvon_disconnect(struct usb_interface *intf)
> +{
> +       struct hanvon *hanvon = usb_get_intfdata(intf);
> +
> +       usb_set_intfdata(intf, NULL);
> +       usb_kill_urb(hanvon->irq);

What happens if there's a call to open() here?

> +       input_unregister_device(hanvon->dev);
> +       usb_free_urb(hanvon->irq);
> +       usb_free_coherent(interface_to_usbdev(intf), USB_AM_PACKET_LEN, hanvon->data, hanvon->data_dma);
> +       kfree(hanvon);
> +}
> +

	Regards
		Oliver

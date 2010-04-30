Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab0D3R2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:28:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34015 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486Ab0D3R1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:27:40 -0400
Date: Fri, 30 Apr 2010 15:51:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Axel Lin <axel.lin@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the usb tree with the input tree
Message-Id: <20100430155108.6847891f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/input/tablet/acecad.c between commits
2ef2ed597669f5e120d0c51c295f00e34b2f0801 ("Input: acecad - fix incorrect
size parameter in usb_buffer_free") and
5492f6f801c81c9663417cd8e48e759775977c83 ("Input: acecad - simplify
usb_acecad_disconnect()") from the input tree and commit
3cc96f50329227fbf34de2459491901b6ee1c98c ("USB: rename usb_buffer_alloc()
and usb_buffer_free() users") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/tablet/acecad.c
index 37d0539,c047016..0000000
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@@ -246,11 -252,13 +246,11 @@@ static void usb_acecad_disconnect(struc
  	struct usb_acecad *acecad = usb_get_intfdata(intf);
  
  	usb_set_intfdata(intf, NULL);
 -	if (acecad) {
 -		usb_kill_urb(acecad->irq);
 -		input_unregister_device(acecad->input);
 -		usb_free_urb(acecad->irq);
 -		usb_free_coherent(interface_to_usbdev(intf), 10, acecad->data, acecad->data_dma);
 -		kfree(acecad);
 -	}
 +
 +	input_unregister_device(acecad->input);
 +	usb_free_urb(acecad->irq);
- 	usb_buffer_free(acecad->usbdev, 8, acecad->data, acecad->data_dma);
++	usb_free_coherent(acecad->usbdev, 8, acecad->data, acecad->data_dma);
 +	kfree(acecad);
  }
  
  static struct usb_device_id usb_acecad_id_table [] = {

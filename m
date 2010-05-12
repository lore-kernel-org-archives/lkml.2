Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0ELF54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:57:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34945 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0ELF5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:57:53 -0400
Date: Wed, 12 May 2010 15:57:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IkplYW4tRnJhbsOnb2lzIE1vaW5lIg==?= <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Daniel Mack <daniel@caiaq.de>
Subject: linux-next: manual merge of the usb tree with the v4l-dvb tree
Message-Id: <20100512155750.c6633e4c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/media/video/gspca/gspca.c between commit
659a02869f4a8be95df9efa76af02e53e400555f ("V4L/DVB: gspca - main: Convert
wMaxPacketSize from little endian 16 to cpu") from the v4l-dvb tree and
commit 42b4658241d4c16c838daf9d63c0029cd7269fe0 ("USB: rename
usb_buffer_alloc() and usb_buffer_free() users") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/video/gspca/gspca.c
index efe6159,00713f8..0000000
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@@ -213,7 -213,7 +213,7 @@@ static int alloc_and_submit_int_urb(str
  		goto error;
  	}
  
- 	buffer = usb_buffer_alloc(dev, buffer_len,
 -	buffer = usb_alloc_coherent(dev, ep->wMaxPacketSize,
++	buffer = usb_alloc_coherent(dev, buffer_len,
  				GFP_KERNEL, &urb->transfer_dma);
  	if (!buffer) {
  		ret = -ENOMEM;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629Ab2J2WP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:15:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:47356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947Ab2J2Vg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fred Brooks <nsaspook@nsaspook.com>, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [ 029/101] staging: comedi: ni_daq_700: fix dio subdevice regression
Date: Mon, 29 Oct 2012 14:34:42 -0700
Message-Id: <20121029213243.450700715@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fred Brooks <nsaspook@nsaspook.com>

commit 6681e63399926651cc29bcb9d92229b6f1cf1daa upstream.

Here is a small patch to fix a problem caused by a previous patch that
removed the  callback function.  The callback remove patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1de02225358988e8fd48d1dc3fd12336bbae258a

I finally booted my dev machine on the latest kernel (running Debian
here so it's still on 3.2 normally) to test the ni_daq_700 driver with
my test program and noticed this bug.

Shift the DIO_R read result to bits 8..15 Digital direction
configuration: channels 0-7 output, 8-15 input (8225 device emu as port
A output, port B input, port C N/A).

Signed-off-by: Fred Brooks <nsaspook@nsaspook.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ni_daq_700.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -71,7 +71,7 @@ static int subdev_700_insn(struct comedi
 	}
 
 	data[1] = s->state & 0xff;
-	data[1] |= inb(dev->iobase + DIO_R);
+	data[1] |= inb(dev->iobase + DIO_R) << 8;
 
 	return insn->n;
 }



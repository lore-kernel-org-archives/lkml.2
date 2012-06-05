Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2FESVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:21:04 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:11057 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2FESVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:21:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1338920454!7569630!20
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: ni_mio_common.c: local functions should be static
Date: Tue, 5 Jun 2012 11:20:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206051120.22177.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local functions should be marked static to prevent them from
being exposed globally.

This quiets the following sparse warnings:

warning: symbol 'ni_release_gpct_mite_channel' was not declared. Should it be static?
warning: symbol 'ni_prime_channelgain_list' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index fd232bc..3b3a0b1 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -644,7 +644,7 @@ static void ni_release_ao_mite_channel(struct comedi_device *dev)
 #endif /*  PCIDMA */
 }
 
-void ni_release_gpct_mite_channel(struct comedi_device *dev,
+static void ni_release_gpct_mite_channel(struct comedi_device *dev,
 				  unsigned gpct_index)
 {
 #ifdef PCIDMA
@@ -1880,7 +1880,7 @@ static int ni_ai_insn_read(struct comedi_device *dev,
 	return insn->n;
 }
 
-void ni_prime_channelgain_list(struct comedi_device *dev)
+static void ni_prime_channelgain_list(struct comedi_device *dev)
 {
 	int i;
 	devpriv->stc_writew(dev, AI_CONVERT_Pulse, AI_Command_1_Register);

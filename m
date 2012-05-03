Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2ECA5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:57:24 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:55830 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2ECA5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:57:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1336006641!10394791!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tty: mxser: local variables should not be exposed globally
Date: Wed, 2 May 2012 17:57:17 -0700
User-Agent: KMail/1.9.9
CC: <jirislaby@gmail.com>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021757.18003.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'mxser_port_ops' is only referenced in this file and
should be marked static to prevent it from being exposed globally.

Quites the sparse warning:

warning: symbol 'mxser_port_ops' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index c6f372d..90cc680 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2326,7 +2326,7 @@ static const struct tty_operations mxser_ops = {
 	.get_icount = mxser_get_icount,
 };
 
-struct tty_port_operations mxser_port_ops = {
+static struct tty_port_operations mxser_port_ops = {
 	.carrier_raised = mxser_carrier_raised,
 	.dtr_rts = mxser_dtr_rts,
 	.activate = mxser_activate,

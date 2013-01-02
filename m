Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3ABBhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 20:37:03 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:36820 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3ABBhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 20:37:00 -0500
Date: Wed, 2 Jan 2013 02:36:56 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH,staging/speakup] Turn some symbols static
Message-ID: <20130102013656.GA28539@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	William Hubbs <w.d.hubbs@gmail.com>,
	Chris Brannon <chris@the-brannons.com>,
	Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org
References: <20130101225257.GC6582@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130101225257.GC6582@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn static some symbols which do not actually need to be
externally-visible

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff -ur linux/drivers/staging/speakup-orig/fakekey.c linux/drivers/staging/speakup/fakekey.c
--- linux/drivers/staging/speakup-orig/fakekey.c	2011-10-24 09:10:05.000000000 +0200
+++ linux/drivers/staging/speakup/fakekey.c	2013-01-01 23:29:42.594104874 +0100
@@ -28,7 +28,7 @@
 #define PRESSED 1
 #define RELEASED 0
 
-DEFINE_PER_CPU(bool, reporting_keystroke);
+static DEFINE_PER_CPU(bool, reporting_keystroke);
 
 static struct input_dev *virt_keyboard;
 
diff -ur linux/drivers/staging/speakup-orig/main.c linux/drivers/staging/speakup/main.c
--- linux/drivers/staging/speakup-orig/main.c	2012-10-01 14:19:04.552069389 +0200
+++ linux/drivers/staging/speakup/main.c	2013-01-01 23:38:06.587701022 +0100
@@ -251,14 +251,14 @@
 static int keyboard_notifier_call(struct notifier_block *,
 				  unsigned long code, void *param);
 
-struct notifier_block keyboard_notifier_block = {
+static struct notifier_block keyboard_notifier_block = {
 	.notifier_call = keyboard_notifier_call,
 };
 
 static int vt_notifier_call(struct notifier_block *,
 			    unsigned long code, void *param);
 
-struct notifier_block vt_notifier_block = {
+static struct notifier_block vt_notifier_block = {
 	.notifier_call = vt_notifier_call,
 };
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1F2Tzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:55:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256Ab1F2Tzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:55:41 -0400
Date: Wed, 29 Jun 2011 12:55:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, rdunlap@xenotime.net,
        mk7.kang@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH v5] misc: adds support the FSA9480 USB Switch
Message-Id: <20110629125534.4895f1d8.akpm@linux-foundation.org>
In-Reply-To: <1309342463-26481-1-git-send-email-dg77.kim@samsung.com>
References: <4D773B82.6010706@samsung.com>
	<1309342463-26481-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 19:14:23 +0900
Donggeun Kim <dg77.kim@samsung.com> wrote:

> The FSA9480 is a USB port accessory detector and switch.
> This patch adds support the FSA9480 USB Switch.
> 
> ...
>
> +static struct fsa9480_usbsw *chip;

So there can only ever be one device per system.  Is this a good
assumption?


Does this fix look OK?

--- a/drivers/misc/fsa9480.c~drivers-misc-add-support-the-fsa9480-usb-switch-fix
+++ a/drivers/misc/fsa9480.c
@@ -145,7 +145,7 @@ static int fsa9480_read_irq(struct i2c_c
 	return ret;
 }
 
-void fsa9480_set_switch(const char *buf)
+static void fsa9480_set_switch(const char *buf)
 {
 	struct fsa9480_usbsw *usbsw = chip;
 	struct i2c_client *client = usbsw->client;
@@ -179,7 +179,7 @@ void fsa9480_set_switch(const char *buf)
 	fsa9480_write_reg(client, FSA9480_REG_CTRL, value);
 }
 
-ssize_t fsa9480_get_switch(char *buf)
+static ssize_t fsa9480_get_switch(char *buf)
 {
 	struct fsa9480_usbsw *usbsw = chip;
 	struct i2c_client *client = usbsw->client;
_


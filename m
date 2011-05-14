Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab1ENTQB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:16:01 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43554 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1ENTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:15:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH] input: Add wiichuck driver
Date: Sat, 14 May 2011 21:17:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
References: <20110512042218.12859.66600.stgit@localhost6.localdomain6>
In-Reply-To: <20110512042218.12859.66600.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105142117.50529.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. Mai 2011, 06:29:44 schrieb Grant Likely:
> +static void wiichuck_poll(struct input_polled_dev *poll_dev)
> +{
> +       struct wiichuck_device *wiichuck = poll_dev->private;
> +       struct i2c_client *i2c = wiichuck->i2c_client;
> +       static uint8_t cmd_byte = 0;
> +       struct i2c_msg cmd_msg =
> +               { .addr = i2c->addr, .len = 1, .buf = &cmd_byte };
> +       uint8_t b[6];
> +       struct i2c_msg data_msg =
> +               { .addr = i2c->addr, .flags = I2C_M_RD, .len = 6, .buf = b };


Do you need these buffers to be capable of DMA?

	Regards
		Oliver

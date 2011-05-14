Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab1ENTU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:20:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35309 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1ENTUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <201105142117.50529.oliver@neukum.org>
References: <20110512042218.12859.66600.stgit@localhost6.localdomain6> <201105142117.50529.oliver@neukum.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 14 May 2011 21:20:04 +0200
X-Google-Sender-Auth: _HNrNMXcJPzE4A5DkCQOK9R6LZo
Message-ID: <BANLkTi=4oCehWLXrKbd6bj2CuoxDXdBHAg@mail.gmail.com>
Subject: Re: [RFC PATCH] input: Add wiichuck driver
To: Oliver Neukum <oliver@neukum.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 9:17 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Donnerstag, 12. Mai 2011, 06:29:44 schrieb Grant Likely:
>> +static void wiichuck_poll(struct input_polled_dev *poll_dev)
>> +{
>> +       struct wiichuck_device *wiichuck = poll_dev->private;
>> +       struct i2c_client *i2c = wiichuck->i2c_client;
>> +       static uint8_t cmd_byte = 0;
>> +       struct i2c_msg cmd_msg =
>> +               { .addr = i2c->addr, .len = 1, .buf = &cmd_byte };
>> +       uint8_t b[6];
>> +       struct i2c_msg data_msg =
>> +               { .addr = i2c->addr, .flags = I2C_M_RD, .len = 6, .buf = b };
>
>
> Do you need these buffers to be capable of DMA?

Good point.  Yes, these buffers should be DMA capable.  I'll pull them
off the stack.

g.

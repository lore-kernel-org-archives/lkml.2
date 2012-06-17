Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2FQRnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:43:16 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55316 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab2FQRnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:43:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FDB3642.5030804@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-10-git-send-email-lee.jones@linaro.org>
	<CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
	<4FD8BAD2.50703@linaro.org>
	<CACRpkdZFi34nChnMEo6yik67zk9owZLk-6zcdP7mmOXyLz8uqQ@mail.gmail.com>
	<4FDAFA17.6050502@linaro.org>
	<CAE2-_9rRYxjU9QQgtBv9ReMY5x+oRiJG1cDQahYHanjDrwVUYA@mail.gmail.com>
	<20120615115042.GA27480@bnru02>
	<4FDB2E57.4030904@linaro.org>
	<20120615130544.GA28537@bnru02>
	<4FDB3642.5030804@linaro.org>
Date: Sun, 17 Jun 2012 19:43:13 +0200
Message-ID: <CACRpkdZ7ESKhokk8Z+6sC9Kq+jPztFNwzger0Db7nCD1fPnG1A@mail.gmail.com>
Subject: Re: Fwd: [PATCH 1/3] i2c: Add Device Tree support to the Nomadik I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gah, what a thread...

On Fri, Jun 15, 2012 at 3:18 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On 15/06/12 14:05, Srinidhi Kasagar wrote:
>> On Fri, Jun 15, 2012 at 14:45:11 +0200, Lee Jones wrote:
>>> On 15/06/12 12:50, Srinidhi Kasagar wrote:

>>>>> +static struct nmk_i2c_controller u8500_i2c = {
>>>>> +       /*
>>>>> +        * Slave data setup time; 250ns, 100ns, and 10ns, which
>>>>> +        * is 14, 6 and 2 respectively for a 48Mhz i2c clock.
>>>>> +        */
>>>>> +       .slsu           = 0xe,
>>>>> +       .tft            = 1,      /* Tx FIFO threshold */
>>>>> +       .rft            = 8,      /* Rx FIFO threshold */
>>>>> +       .clk_freq       = 100000, /* std. mode operation */
>>>>> +       .timeout        = 200,    /* Slave response timeout(ms) */
>>>>> +       .sm             = I2C_FREQ_MODE_FAST,
>>>>
>>>> How is this possible? you are setting clk_freq as 100kb/s and mode
>>>> as fast mode which is supposed to be 400kb/s.
>>>
>>> That's not how I read it:
>>
>>
>> But it is not readable. It confuses people.
>
> I understood it. :)
>
> If you think it's unclear speak to the author, Linus. He's CC'ed.

Author of what? The i2c driver was written by Srinidhi. (The
MODULE_AUTHOR() clause should be a good hint...)

But it's true that board data for the ux500 kernel use
100000 Hz and I2C_FREQ_MODE_FAST, in the board-mop500.c
file, like this:

U8500_I2C_CONTROLLER(0, 0xe, 1, 8, 100000, 200, I2C_FREQ_MODE_FAST);
U8500_I2C_CONTROLLER(1, 0xe, 1, 8, 100000, 200, I2C_FREQ_MODE_FAST);
U8500_I2C_CONTROLLER(2, 0xe, 1, 8, 100000, 200, I2C_FREQ_MODE_FAST);
U8500_I2C_CONTROLLER(3, 0xe, 1, 8, 100000, 200, I2C_FREQ_MODE_FAST);

This is indeed a bit odd. But obviously it works... But reading some
fixes in another tree it seems it should look like this:

/*
 * The board uses 4 i2c controllers, initialize all of
 * them with slave data setup time of 250 ns,
 * Tx & Rx FIFO threshold values as 1 and standard
 * mode of operation
 */
U8500_I2C_CONTROLLER(0, 0xe, 1, 8, 400000, 200, I2C_FREQ_MODE_FAST);
U8500_I2C_CONTROLLER(1, 0xe, 1, 8, 400000, 200, I2C_FREQ_MODE_FAST);
U8500_I2C_CONTROLLER(2, 0xe, 1, 8, 400000, 200, I2C_FREQ_MODE_FAST);
U8500_I2C_CONTROLLER(3, 0xe, 1, 8, 400000, 200, I2C_FREQ_MODE_FAST);

Which makes *much* more sense.

I'll cook a separate patch for this or something.

Thanks,
Linus Walleij

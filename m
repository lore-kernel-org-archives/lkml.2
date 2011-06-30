Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1F3IRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:17:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41326 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab1F3IRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <4E02FD74.8020503@dsn.okisemi.com>
References: <1308813430-2697-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <201106230952.09286.alexander.stein@systec-electronic.com> <4E02FD74.8020503@dsn.okisemi.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 30 Jun 2011 10:16:59 +0200
Message-ID: <BANLkTi=zDMnwX5xYFazM3qb17wa6yY4LZw@mail.gmail.com>
Subject: Re: [PATCH] i2c-eg20t : Fix the issue of Combined R/W transfer mode
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/23 Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>:
> (2011/06/23 16:52), Alexander Stein wrote:
>>
>> Do you have any other local pending patches which are not in git yet? I
>> can't
>> find this for loop in current master.
>>
>
> I sent a patch for i2c-eg20t in 9-June which haven't been reviewed yet by
> i2c maintainer.
>

I have tried both patches, as I need combined R/W with i2c-eg20t to
work. I have some devices connected
on this bus, but I don't get them to work.

- lm75 probe failed
- at24 eeprom read failed
- i2cdetect works sometimes

I am using a Intel Corporation Platform Controller Hub EG20T I2C
Controller [8086:8817].


This happens, when I want to readout the eeprom:

[ 2222.113891] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
[ 2222.113906] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
[ 2222.113919] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[ 2222.113931] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[ 2222.113941] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[ 2222.113957] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
398 msgs->len = 1
[ 2222.134154] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 28
[ 2222.134171] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
[ 2222.184143] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_xfer_complete
:timeout: 0
[ 2222.207152] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3b8
[ 2222.207185] at24 0-0050: read 128@0 --> -5 (1922207)
[ 2222.209093] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
[ 2222.209107] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
[ 2222.209118] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[ 2222.209129] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[ 2222.209140] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[ 2222.209156] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
398 msgs->len = 1
[ 2222.230144] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 28
[ 2222.230159] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
[ 2222.280142] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_xfer_complete
:timeout: 0
[ 2222.303171] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3b8
[ 2222.303202] at24 0-0050: read 128@0 --> -5 (1922303)

I looks like I am running in timeouts.

--
Christian Gmeiner, MSc

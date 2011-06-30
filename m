Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1F3OIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:08:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53799 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1F3OIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=zDMnwX5xYFazM3qb17wa6yY4LZw@mail.gmail.com>
References: <1308813430-2697-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <201106230952.09286.alexander.stein@systec-electronic.com>
 <4E02FD74.8020503@dsn.okisemi.com> <BANLkTi=zDMnwX5xYFazM3qb17wa6yY4LZw@mail.gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 30 Jun 2011 16:08:18 +0200
Message-ID: <BANLkTi=y43pWQC9wxjSPCEbr47hTYbJF6w@mail.gmail.com>
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

2011/6/30 Christian Gmeiner <christian.gmeiner@gmail.com>:
> 2011/6/23 Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>:
>> (2011/06/23 16:52), Alexander Stein wrote:
>>>
>>> Do you have any other local pending patches which are not in git yet? I
>>> can't
>>> find this for loop in current master.
>>>
>>
>> I sent a patch for i2c-eg20t in 9-June which haven't been reviewed yet by
>> i2c maintainer.
>>
>
> I have tried both patches, as I need combined R/W with i2c-eg20t to
> work. I have some devices connected
> on this bus, but I don't get them to work.
>
> - lm75 probe failed
> - at24 eeprom read failed
> - i2cdetect works sometimes
>
> I am using a Intel Corporation Platform Controller Hub EG20T I2C
> Controller [8086:8817].
>
>
> This happens, when I want to readout the eeprom:
>
> [ 2222.113891] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
> [ 2222.113906] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
> [ 2222.113919] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
> :adap->p_adapter_info->pch_i2c_suspended is 0
> [ 2222.113931] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
> I2C_MODE_SEL :flag= 0x0
> [ 2222.113941] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
> [ 2222.113957] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
> 398 msgs->len = 1
> [ 2222.134154] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 28
> [ 2222.134171] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
> [ 2222.184143] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_xfer_complete
> :timeout: 0
> [ 2222.207152] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3b8
> [ 2222.207185] at24 0-0050: read 128@0 --> -5 (1922207)
> [ 2222.209093] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
> [ 2222.209107] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
> [ 2222.209118] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
> :adap->p_adapter_info->pch_i2c_suspended is 0
> [ 2222.209129] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
> I2C_MODE_SEL :flag= 0x0
> [ 2222.209140] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
> [ 2222.209156] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
> 398 msgs->len = 1
> [ 2222.230144] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 28
> [ 2222.230159] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
> [ 2222.280142] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_xfer_complete
> :timeout: 0
> [ 2222.303171] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3b8
> [ 2222.303202] at24 0-0050: read 128@0 --> -5 (1922303)
>
> I looks like I am running in timeouts.
>

I have some more research and it looks like I don't get any
interrupts. I have added a printk to
the irq handler and I am able to reproduce my problem very fast.

1) i2cdetect -> works

[  162.801551] i2c i2c-0: ioctl, cmd=0x703, arg=0x48
[  162.801570] i2c i2c-0: ioctl, cmd=0x720, arg=0xbfe3cd5c
[  162.801589] i2c i2c-0: master_xfer[0] W, addr=0x48, len=0
[  162.801605] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[  162.801621] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[  162.801637] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[  162.801658] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
390 msgs->len = 0
[  162.801679] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 9
[  162.801695] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 390
[  162.801999] i2c_eg20t irq
[  162.802456] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  162.804816] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3b0
[  162.804832] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :return=0
[  162.804846] i2c i2c-0: handled 1 msgs

2) modprobe lm75

[  190.647667] i2c-core: driver [lm75] registered
[  190.647692] i2c i2c-0: found normal entry for adapter 0, addr 0x48
[  190.647715] i2c i2c-0: master_xfer[0] W, addr=0x48, len=0
[  190.647731] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[  190.647748] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[  190.647762] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[  190.647783] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
398 msgs->len = 0
[  190.647805] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 9
[  190.647821] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
[  190.648127] i2c_eg20t irq
[  190.649136] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.650679] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3b8
[  190.650697] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :return=0
[  190.650712] i2c i2c-0: handled 1 msgs
[  190.650730] i2c i2c-0: master_xfer[0] W, addr=0x48, len=1
[  190.650745] i2c i2c-0: master_xfer[1] R, addr=0x48, len=1
[  190.650760] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[  190.650776] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[  190.650791] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[  190.650813] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
398 msgs->len = 1
[  190.650836] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 8
[  190.650854] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
[  190.651157] i2c_eg20t irq
[  190.652013] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.653607] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :writing 1
to Data register
[  190.653862] i2c_eg20t irq
[  190.654564] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.656313] i2c_eg20t 0000:02:0c.2: pch_i2c_repstart :I2CCTL = 3b8
[  190.656331] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :return=1
[  190.656345] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x1
[  190.656360] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_readbytes
[  190.656680] i2c_eg20t irq
[  190.657279] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.659042] i2c_eg20t 0000:02:0c.2: pch_i2c_readbytes :return 0
[  190.659060] i2c_eg20t 0000:02:0c.2: pch_i2c_sendack :I2CCTL = 3a8
[  190.659080] i2c_eg20t 0000:02:0c.2: pch_i2c_sendnack :I2CCTL = 3a0
[  190.659356] i2c_eg20t irq
[  190.660015] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.661710] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3a8
[  190.661732] i2c i2c-0: handled 2 msgs
[  190.661751] i2c i2c-0: master_xfer[0] W, addr=0x48, len=1
[  190.661767] i2c i2c-0: master_xfer[1] R, addr=0x48, len=1
[  190.661783] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[  190.661800] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[  190.661815] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[  190.661837] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
398 msgs->len = 1
[  190.661860] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 8
[  190.661878] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
[  190.662182] i2c_eg20t irq
[  190.663013] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.664575] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :writing 7
to Data register
[  190.664830] i2c_eg20t irq
[  190.665536] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.667187] i2c_eg20t 0000:02:0c.2: pch_i2c_repstart :I2CCTL = 3b8
[  190.667205] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :return=1
[  190.667220] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x1
[  190.667236] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_readbytes
[  190.667559] i2c_eg20t irq
[  190.668142] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.669903] i2c_eg20t 0000:02:0c.2: pch_i2c_readbytes :return 0
[  190.669921] i2c_eg20t 0000:02:0c.2: pch_i2c_sendack :I2CCTL = 3a8
[  190.669941] i2c_eg20t 0000:02:0c.2: pch_i2c_sendnack :I2CCTL = 3a0
[  190.670217] i2c_eg20t irq
[  190.671013] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.672567] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3a8
[  190.672588] i2c i2c-0: handled 2 msgs
[  190.672605] i2c i2c-0: master_xfer[0] W, addr=0x48, len=1
[  190.672622] i2c i2c-0: master_xfer[1] R, addr=0x48, len=1
[  190.672637] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[  190.672654] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[  190.672669] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[  190.672691] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
398 msgs->len = 1
[  190.672713] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 8
[  190.672731] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
[  190.673034] i2c_eg20t irq
[  190.674015] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.675425] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :writing 2
to Data register
[  190.675681] i2c_eg20t irq
[  190.676388] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.678032] i2c_eg20t 0000:02:0c.2: pch_i2c_repstart :I2CCTL = 3b8
[  190.678050] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :return=1
[  190.678065] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x1
[  190.678080] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_readbytes
[  190.678403] i2c_eg20t irq
[  190.679015] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.680749] i2c_eg20t 0000:02:0c.2: pch_i2c_readbytes :return 0
[  190.680768] i2c_eg20t 0000:02:0c.2: pch_i2c_sendack :I2CCTL = 3a8
[  190.680787] i2c_eg20t 0000:02:0c.2: pch_i2c_sendnack :I2CCTL = 3a0
[  190.681063] i2c_eg20t irq
[  190.682013] i2c_eg20t 0000:02:0c.2: pch_i2c_cb :PCH_I2CSR = 28
[  190.683408] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3a8
[  190.683429] i2c i2c-0: handled 2 msgs
[  190.683446] i2c i2c-0: master_xfer[0] W, addr=0x48, len=1
[  190.683462] i2c i2c-0: master_xfer[1] R, addr=0x48, len=1
[  190.683477] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[  190.683494] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[  190.683509] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[  190.683530] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
398 msgs->len = 1
[  190.704153] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 28
[  190.704168] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
[  190.754135] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_xfer_complete
:timeout1: 0
[  190.759599] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3b8
[  190.759617] i2c i2c-0: handled -5 msgs


3) i2cdetect -> broken

[  221.794332] i2c i2c-0: ioctl, cmd=0x703, arg=0x48
[  221.794355] i2c i2c-0: ioctl, cmd=0x720, arg=0xbfac33ec
[  221.794373] i2c i2c-0: master_xfer[0] W, addr=0x48, len=0
[  221.794390] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer
:adap->p_adapter_info->pch_i2c_suspended is 0
[  221.794407] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :After invoking
I2C_MODE_SEL :flag= 0x0
[  221.794423] i2c_eg20t 0000:02:0c.2: pch_i2c_xfer :invoking pch_i2c_writebytes
[  221.794445] i2c_eg20t 0000:02:0c.2: pch_i2c_writebytes :I2CCTL =
398 msgs->len = 0
[  221.815151] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_bus_idle :I2CSR = 28
[  221.815167] i2c_eg20t 0000:02:0c.2: pch_i2c_start :I2CCTL = 398
[  221.865148] i2c_eg20t 0000:02:0c.2: pch_i2c_wait_for_xfer_complete
:timeout1: 0
[  221.889066] i2c_eg20t 0000:02:0c.2: pch_i2c_stop :I2CCTL = 3b8
[  221.889082] i2c i2c-0: handled -5 msgs


I am studying the datasheet and the driver... hope to find out whats wrong.

--
Christian Gmeiner, MSc

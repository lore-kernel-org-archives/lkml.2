Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab2EYJyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:54:08 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:33112
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756914Ab2EYJyG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:54:06 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -15
X-BigFish: VPS-15(zz9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839hd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Date: Fri, 25 May 2012 05:54:13 -0400
Subject: RE: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register
 access Macro to head file.
Thread-Topic: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register
 access Macro to head file.
Thread-Index: Ac06W5TkLZ4D4/OSTUWFvSrZSRuHuQAAG/NA
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D170230E5ADF@NWD2CMBX1.ad.analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-8-git-send-email-sonic.zhang@analog.com>
 <CAM=Q2csSuQ3R9U=XKwj9F0xijTxx_ULperAiQYD_X3a5GKVjFg@mail.gmail.com>
In-Reply-To: <CAM=Q2csSuQ3R9U=XKwj9F0xijTxx_ULperAiQYD_X3a5GKVjFg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
>Sent: Friday, May 25, 2012 5:48 PM
>To: Zhang, Sonic
>Cc: Ben Dooks; Wolfram Sang; linux-i2c@vger.kernel.org; LKML; uclinux-dist-
>devel@blackfin.uclinux.org
>Subject: Re: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register access
>Macro to head file.
>
>Hi ,
>Some minor comments/ doubts.
>On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>
>A small description may be helpful.
>Also the $SUBJECT says move the patch looks more like the remove.
>Am I missing something.

The subject says these definitions are moved to a head file by the other patch for Blackfin architecture.

Regards,

Sonic

>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> ---
>>  drivers/i2c/busses/i2c-bfin-twi.c |   45 -------------------------------------
>>  1 files changed, 0 insertions(+), 45 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
>> index b2ca317..e6a0cba 100644
>> --- a/drivers/i2c/busses/i2c-bfin-twi.c
>> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
>> @@ -33,51 +33,6 @@
>>  #define TWI_I2C_MODE_COMBINED          3
>>  #define TWI_I2C_MODE_REPEAT            4
>>
>> -struct bfin_twi_iface {
>> -       int                     irq;
>> -       spinlock_t              lock;
>> -       char                    read_write;
>> -       u8                      command;
>> -       u8                      *transPtr;
>> -       int                     readNum;
>> -       int                     writeNum;
>> -       int                     cur_mode;
>> -       int                     manual_stop;
>> -       int                     result;
>> -       struct i2c_adapter      adap;
>> -       struct completion       complete;
>> -       struct i2c_msg          *pmsg;
>> -       int                     msg_num;
>> -       int                     cur_msg;
>> -       u16                     saved_clkdiv;
>> -       u16                     saved_control;
>> -       void __iomem            *regs_base;
>> -};
>> -
>> -
>> -#define DEFINE_TWI_REG(reg, off) \
>> -static inline u16 read_##reg(struct bfin_twi_iface *iface) \
>> -       { return bfin_read16(iface->regs_base + (off)); } \
>> -static inline void write_##reg(struct bfin_twi_iface *iface, u16 v) \
>> -       { bfin_write16(iface->regs_base + (off), v); }
>> -
>> -DEFINE_TWI_REG(CLKDIV, 0x00)
>> -DEFINE_TWI_REG(CONTROL, 0x04)
>> -DEFINE_TWI_REG(SLAVE_CTL, 0x08)
>> -DEFINE_TWI_REG(SLAVE_STAT, 0x0C)
>> -DEFINE_TWI_REG(SLAVE_ADDR, 0x10)
>> -DEFINE_TWI_REG(MASTER_CTL, 0x14)
>> -DEFINE_TWI_REG(MASTER_STAT, 0x18)
>> -DEFINE_TWI_REG(MASTER_ADDR, 0x1C)
>> -DEFINE_TWI_REG(INT_STAT, 0x20)
>> -DEFINE_TWI_REG(INT_MASK, 0x24)
>> -DEFINE_TWI_REG(FIFO_CTL, 0x28)
>> -DEFINE_TWI_REG(FIFO_STAT, 0x2C)
>> -DEFINE_TWI_REG(XMT_DATA8, 0x80)
>> -DEFINE_TWI_REG(XMT_DATA16, 0x84)
>> -DEFINE_TWI_REG(RCV_DATA8, 0x88)
>> -DEFINE_TWI_REG(RCV_DATA16, 0x8C)
>> -
>>  static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>>                                        unsigned short twi_int_status)
>>  {
>> --
>> 1.7.0.4
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



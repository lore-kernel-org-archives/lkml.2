Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1GDDLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 23:11:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63960 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1GDDLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 23:11:03 -0400
MIME-Version: 1.0
Reply-To: DChang@novell.com
In-Reply-To: <BANLkTimG_kWr_YPVMasUr+7+KRFPnnbjNw@mail.gmail.com>
References: <4DDBF8BD.3000603@freemail.hu>
	<20110524183448.GA18511@kroah.com>
	<4DDC142E.6070003@freemail.hu>
	<20110525031222.GB14290@haskell.muteddisk.com>
	<4DDC93D5.9070607@freemail.hu>
	<4DDDFDA7.6030900@freemail.hu>
	<4E097A32.1000504@freemail.hu>
	<BANLkTimG_kWr_YPVMasUr+7+KRFPnnbjNw@mail.gmail.com>
Date: Mon, 4 Jul 2011 11:11:01 +0800
X-Google-Sender-Auth: Won6GkOX2kBcHfRqLqG6jJwvcdM
Message-ID: <CAL-cBk1L8dgAtP2hMwkL2B-cU76mKaaWib=QVbVKei2DaoB3Dw@mail.gmail.com>
Subject: Re: [PATCH, RFC] USBIP protocol documentation
From: David Chang <dchang@novell.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
        Max Vozeler <max@vozeler.com>, Matt Mooney <mfm@muteddisk.com>,
        Joe Perches <joe@perches.com>, linux-usb@vger.kernel.org,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Németh,

2011/6/29 David Chang <dchang@novell.com>:
> Hi,
>
> Thanks for your great effort.
> Just a little comment on UNLINK pdu size.
>
> 2011/6/28 Németh Márton <nm127@freemail.hu>:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> USBIP v1.0.0 protocol documentation.
>>
>> Signed-off-by: Márton Németh <nm127@freemail.hu>
>> ---
>> +USBIP_CMD_UNLINK: Unlink an URB
>> +
>> + Offset    | Length | Value      | Meaning
>> +-----------+--------+------------+---------------------------------------------------
>> + 0         | 4      | 0x00000003 | command: URB unlink command
>> +-----------+--------+------------+---------------------------------------------------
>> + 4         | 4      |            | seqnum: URB sequence number to unlink: FIXME: is this so?
>> +-----------+--------+------------+---------------------------------------------------
>> + 8         | 4      |            | devid
>> +-----------+--------+------------+---------------------------------------------------
>> + 0xC       | 4      |            | direction: 0: USBIP_DIR_IN
>> +           |        |            |            1: USBIP_DIR_OUT
>> +-----------+--------+------------+---------------------------------------------------
>> + 0x10      | 4      |            | ep: endpoint number: zero
>> +-----------+--------+------------+---------------------------------------------------
>> + 0x14      | 4      |            | seqnum: the URB sequence number given previously
>> +           |        |            |   at USBIP_CMD_SUBMIT.seqnum field
-----------+--------+------------+---------------------------------------------------
0x30       | n        |                 | URB data bytes. For ISO
transfers the padding
               |           |                 |   between each ISO
packets is not transmitted.

>> +
>> +USBIP_RET_UNLINK: Reply for URB unlink
>> +
>> + Offset    | Length | Value      | Meaning
>> +-----------+--------+------------+---------------------------------------------------
>> + 0         | 4      | 0x00000004 | command: reply for the URB unlink command
>> +-----------+--------+------------+---------------------------------------------------
>> + 4         | 4      |            | seqnum: the unlinked URB sequence number
>> +-----------+--------+------------+---------------------------------------------------
>> + 8         | 4      |            | devid
>> +-----------+--------+------------+---------------------------------------------------
>> + 0xC       | 4      |            | direction: 0: USBIP_DIR_IN
>> +           |        |            |            1: USBIP_DIR_OUT
>> +-----------+--------+------------+---------------------------------------------------
>> + 0x10      | 4      |            | ep: endpoint number
>> +-----------+--------+------------+---------------------------------------------------
>> + 0x14      | 4      |            | status: This is the value contained in the
>> +           |        |            |   urb->status in the URB completition handler.
>> +           |        |            |   FIXME: a better explanation needed.
-----------+--------+------------+---------------------------------------------------
0x30       | n        |                 | URB data bytes. For ISO
transfers the padding
              |           |                 |   between each ISO
packets is not transmitted.

Would you add this field into your path or should I send another patch
to add it?
Thanks.

Regards,
David Chang

>
> Regards,
> David Chang
>
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>>
>

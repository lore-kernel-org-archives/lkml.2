Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0J2FHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:07:25 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:43288 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0J2FHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:07:18 -0400
Date: Fri, 29 Oct 2010 13:07:16 +0800
From: marui <m00150988@huawei.com>
Subject: Re: [PATCH] fix oops in usbserial_cleanup function
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        zihan@huawei.com, wangyeqi@huawei.com
Message-id: <002b01cb7727$27b62730$ba260b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <fadccdfb103f0.103f0fadccdfb@huawei.com>
 <Pine.LNX.4.44L0.1010151009050.1603-100000@iolanthe.rowland.org>
 <20101015190913.GA8098@kroah.com>
 <00a801cb75a5$faf0a680$ba260b0a@china.huawei.com>
 <20101027103247.38d88ece@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for your responds.

the card use option.ko

Bestregards
marui
----- Original Message ----- 
From: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
To: "marui" <m00150988@huawei.com>
Cc: "Greg KH" <greg@kroah.com>; "Alan Stern" <stern@rowland.harvard.edu>; "USB list" <linux-usb@vger.kernel.org>; "Kernel development list" <linux-kernel@vger.kernel.org>; <zihan@huawei.com>; <wangyeqi@huawei.com>
Sent: Wednesday, October 27, 2010 5:32 PM
Subject: Re: [PATCH] fix oops in usbserial_cleanup function


>> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999651] serial_cleanup - port 5
>> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999653] destroy_serial - (null)
> 
> So someone called destroy serial with serial->type->desc NULL
> 
>> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999654] return_serial
>> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999671] BUG: unable to handle kernel NULL pointer dereference at (null)
>> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999675] IP: [<(null)>] (null)
> 
> And serial->type->release NULL
> 
>> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999762]  [<fb877b40>] ? destroy_serial+0x80/0xd0 [usbserial]
>> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999765]  [<fb877ac0>] ? destroy_serial+0x0/0xd0 [usbserial]
>> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999770]  [<c03f351a>] ? kref_put+0x2a/0x60
> 
> Which came from the tty close (which will be after the hangup if you
> pulled the card out with the modem in use). Kref leak perhaps ?
> 
> What driver is actually being used for the card itself ?
> 
> Alan

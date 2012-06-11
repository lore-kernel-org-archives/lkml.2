Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2FKQIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:08:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34450 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab2FKQIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:08:52 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: gadget: mass_storage: add documentation
References: <Pine.LNX.4.44L0.1206111021400.1607-100000@iolanthe.rowland.org>
Date: Mon, 11 Jun 2012 18:08:49 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wfqxszn43l0zgt@mpn-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1206111021400.1607-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/12.00 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 11 Jun 2012, Michal Nazarewicz wrote:
>> +  Mass Storage Gadget (or MSG) acts as a USB Mass Storage device,
>> +  appearing to the host as a disk or a CD-ROM drive.  It supports
>> +  multiple logical units (LUNs).  Backing storage for each LUN is
>> +  provided by a regular file or a block device, access can be limited
>> +  to read-only, and gadget can indicate that it is removable and/or
>> +  CD-ROM (the latter implies read-only access).

On Mon, 11 Jun 2012 17:25:15 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> Does CD-ROM really imply read-only?  If not, shouldn't it?

It indeed does:

		curlun->ro = lcfg->cdrom || lcfg->ro;

>> +  - ro=b[,b...]
>> +
>> +    This parameter specifies whether each logical unit should be
>> +    reported as read only.  This will prevent host from modifying the
>> +    backing files.
>> +
>> +    Note that if this flag for given logical unit is false but the
>> +    backing file could not be opened in read/write mode, the gadget
>> +    will fall back to read only mode anyway.
>> +
>> +    The default value for each logical unit is false.
>
> Shouldn't the default be true for logical units that are cdroms?

Indeed.  I've changed this last line to: The default value for non-CD-ROM
logical units is false; for logical units simulating CD-ROM it is forced
to true.

> Very good.  When you make the small changes listed above, you can add
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

I'll resend it tomorrow in case anyone else has any comments.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

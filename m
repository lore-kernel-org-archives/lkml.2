Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2K0PUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:20:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:34851 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2K0PUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:20:50 -0500
Message-ID: <50B4DA4E.3020900@linutronix.de>
Date: Tue, 27 Nov 2012 16:20:46 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <xa1ty5hogv6j.fsf@mina86.com> <50B3A1A0.2000607@linutronix.de> <xa1ttxscgsht.fsf@mina86.com>
In-Reply-To: <xa1ttxscgsht.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 06:54 PM, Michal Nazarewicz wrote:
> On Mon, Nov 26 2012, Sebastian Andrzej Siewior wrote:
>> Wouldn't say that. It may adds complexity on another level. The target
>> subsystem has the same problem with adding luns and there seems nothing
>> wrong with having lun3 and 4 and leaving 0 and 1 unsued.
>
> That's not what Wikipedia claims though (from
> <http://en.wikipedia.org/wiki/Logical_Unit_Number>):
>
> 	LUN 0: There is one LUN which is required to exist in every
> 	target: zero. The logical unit with LUN zero is special in that
> 	it must implement a few specific commands, most notably Report
> 	LUNs, which is how an initiator can find out all the other LUNs
> 	in the target. But LUN zero need not provide any other services,
> 	such as a storage volume.
>
> That's why I proposed solution where one needs to have continuous
> numbering of LUNs.  I'm not an expert on SCSI though.

Let me quote "4.6.4 Minimum LUN addressing requirements" of SAM4:

| All SCSI target devices shall support LUN 0 (i.e., 00000000
| 00000000h) or the REPORT LUNS well-known logical unit. For SCSI
| target devices that support the hierarchical addressing model the LUN
| 0 or the REPORT LUNS well-known logical unit shall be the logical
| unit that an application client addresses to determine
| information about the SCSI target device and the logical units
| contained within the SCSI target device.

Nab, I think not having LUN0 configured as long as REPORT LUNS says
which luns are available is fine. Target seems to work on linux without
it and SAM4 does no claim otherwise unless I miss interpret it. Any
opinion on this from your side?

>
>> With the tcm gadget I get:
>>
>> |scsi 0:0:0:2: Direct-Access     LIO-ORG  RAMDISK-MCP      4.0  PQ: 0
>> ANSI: 5
>> |scsi 0:0:0:3: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0
>> ANSI: 5
>>
>> You notice :2 and :3 instead :0 and :1. While should be there something
>> wrong with this?
>
> It may be that it works on Linux but fails on some other systems (or
> even older Linux kernels).  Like I've said, I'm not SCSI expert, so my
> knowledge of it is (embarrassingly) minimal.

Sure but still. You limit the user to create lunX folders where X can
be 0..255 for instance. If the user chooses not create lun0, why force
him?

Sebastian

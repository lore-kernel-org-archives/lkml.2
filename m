Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2KZR6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:58:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:56842 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab2KZRGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:43 -0500
Message-ID: <50B3A1A0.2000607@linutronix.de>
Date: Mon, 26 Nov 2012 18:06:40 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <xa1ty5hogv6j.fsf@mina86.com>
In-Reply-To: <xa1ty5hogv6j.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 05:56 PM, Michal Nazarewicz wrote:
>> On 11/26/2012 09:35 AM, Andrzej Pietrasiewicz wrote:
>>> In some parts of the kernel (e.g. planned configfs integration into usb
>>> gadget) there is a need to programmatically create config groups
>>> (directories) but it would be preferable to disallow creating them by
>>> the user. This is more or less what default_groups used to be for.
>>> But e.g. in the mass storage gadget, after storing the number of
>>> luns (logical units) into some configfs attribute, the corresponding lun#
>>> directories should be created, their number is not known up front so
>>> default_groups are no good for this.
>>>
>>> Example:
>>>
>>> $ echo 3>   /cfg/..../mass_storage/luns
>>>
>>> causes
>>>
>>> /cfg/....../mass_storage/lun0
>>> /cfg/....../mass_storage/lun1
>>> /cfg/....../mass_storage/lun2
>
> On Mon, Nov 26 2012, Sebastian Andrzej Siewior wrote:
>> I though we did not want the luns file but instead use
>>
>> mkdir /cfg/....../mass_storage/lun0
>> mkdir /cfg/....../mass_storage/lun1
>>
>> directly.
>
> I think that's suboptimal, and we can do better.  There are too many
> corner cases (ie. what if user does “mkdir lun7” without the previous
> luns?), it adds complexity to the kernel (ie. parsing of the name), and
> the thing is overly complicated for user (“echo 5>  nluns” is much nicer
> than having to create 5 directories).

Wouldn't say that. It may adds complexity on another level. The target
subsystem has the same problem with adding luns and there seems nothing
wrong with having lun3 and 4 and leaving 0 and 1 unsued.
With the tcm gadget I get:

|scsi 0:0:0:2: Direct-Access     LIO-ORG  RAMDISK-MCP      4.0  PQ: 0 
ANSI: 5
|scsi 0:0:0:3: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 
ANSI: 5

You notice :2 and :3 instead :0 and :1. While should be there something
wrong with this?

Sebastian

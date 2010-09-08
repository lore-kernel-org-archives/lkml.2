Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0IHS3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:29:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33625 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab0IHS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:29:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C87D5E9.1060307@s5r6.in-berlin.de>
Date: Wed, 08 Sep 2010 20:28:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Pedro Francisco <pedrogfrancisco@gmail.com>
CC: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.4: sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem access
 errors follow
References: <201009071834.27953.pedrogfrancisco@gmail.com> <20100907202143.02cf60ec@varda> <201009072247.18438.pedrogfrancisco@gmail.com>
In-Reply-To: <201009072247.18438.pedrogfrancisco@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pedro Francisco wrote:
> On Tuesday 07 September 2010 19:21:43 Alejandro Riveira Fernández wrote:
>> El Tue, 7 Sep 2010 18:34:27 +0100
>>
>> Pedro Francisco <pedrogfrancisco@gmail.com> escribió:
>>> sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem access errors follow.
>>>
>>> Now what I'm surprised is not the filesystem errors but me being allowed
>>> to remove the module without using the '-f' option.
>>>
>>> Do note, lsmod |grep ahci reports something like [this is adapted from a
>>> 2.6.32 kernel]:
>>>
>>> ahci                   32200  0
>>>
>>> so it isn't at all surprising I'm being allowed to remove a seemingly
>>> unused module. So....
>>> a) is this supposed to happen?
>>  Yes afaics. root can do many stupid things if (s)he wants
>>  including « rm -rf --no-preserve-root / »
> 
> That makes no sense. That's what the force option "-f" is for. It's my opinion 
> the usage count for ahci on `lsmod' should be 1 and not 0. Whoever still wants 
> to remove it can use the `rmmod -f ahci'

The usage count of a module is only there to ensure that function calls into
the module succeed.  As long as some other part of the kernel has a pointer of
a function in the module, removal of the module needs to be prevented.

"rmmod ahci" on the other hand is something like pulling the SATA cable.  Or
ejection of the controller from an ExpressCard slot.  The driver shutdown
causes the controller device and thus its child devices (disk devices behind
the controller) to go away, and that's it.  You can do also
# echo $DEVICE_ID > /sys/module/ahci/drivers/pci\:ahci/unbind
which tells the driver to let go of the controller.
-- 
Stefan Richter
-=====-==-=- =--= -=---
http://arcgraph.de/sr/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1HaO1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:27:25 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:13889 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1HaO1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:27:24 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>, Greg KH <greg@kroah.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 0000/0046] Staging: hv: Driver cleanup
Thread-Topic: [PATCH 0000/0046] Staging: hv: Driver cleanup
Thread-Index: AQHMZOnf4RrKbuc3xkO79xj3e0N/35U10eAA///VXKCAAHzxAIAABeMAgADfS6A=
Date: Wed, 31 Aug 2011 14:27:23 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B5549@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <20110830124856.GA17520@aepfle.de>
 <6E21E5352C11B742B20C142EB499E048081B5363@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110830174330.GE22868@kroah.com> <20110830180434.GA10090@aepfle.de>
In-Reply-To: <20110830180434.GA10090@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7VERe4t000751



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, August 30, 2011 2:05 PM
> To: Greg KH
> Cc: KY Srinivasan; devel@linuxdriverproject.org; gregkh@suse.de; linux-
> kernel@vger.kernel.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
> 
> On Tue, Aug 30, Greg KH wrote:
> 
> > > > In my test system, the IDE drives are now discovered twice, once by
> > > > hv_storvsc and once by libata:
> > >
> > > This is a known (old problem). The way this was handled earlier was to have
> the
> > > modprobe rules in place to setup a dependency that would force the load of
> the
> > > hyper-v driver (blk / stor) ahead of the native driver and if the load of the PV
> > > driver succeeded, we would not load the native driver. In sles11 sp1, we had a
> rule for
> > > loading blkvsc. With the merge of blkvsc and storvsc, the only change we
> need to make
> > > is to have storvsc in the rule (instaed of blkvsc).
> >
> > Why do we need a rule at all?  Shouldn't the module dependancy stuff
> > handle the autoloading of the drivers properly from the initrd now that
> > the hotplug logic is hooked up properly?
> 
> There is no plan to load hv_vmbus (or xen-platform-pci) earlier than
> native drivers.  That was the purpose of the modprobe.conf files. Now
> that there is a vmbus, that fact could be checked before any other
> attempt to load drivers is made and hv_vmbus should be loaded and all of
> its devices have to be probed manually by modprobe `cat modulealias`.

The strategy I was describing was what was used in sles11 sp1.

> 
> > Or is the hotplug code not working correctly?
> 
> There is nothing to hotplug. hv_vmbus has to be loaded first so that it
> can take over the devices. But it seems that there is no shutdown of the
> emulated hardware, thats why the disk "sda" is shown twice.
> 
> I spot a flaw here.
> KY, can hv_vmbus shutdown emulated hardware? At least the disks, because
> cdroms are appearently still be handled by native drivers?

Olaf, unfortunately the vmbus driver does not stop the emulation of the disk devices.
The earlier modprobe rule was also instrumental in preventing the loading of the
native drivers if the hyperv- driver load succeeded.

Regards,

K. Y 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

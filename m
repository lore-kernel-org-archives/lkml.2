Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1H3SEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:04:52 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:45173 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1H3SEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:04:51 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjzYQEROTxg==
X-RZG-CLASS-ID: mo00
Date: Tue, 30 Aug 2011 20:04:34 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Greg KH <greg@kroah.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
Message-ID: <20110830180434.GA10090@aepfle.de>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <20110830124856.GA17520@aepfle.de>
 <6E21E5352C11B742B20C142EB499E048081B5363@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110830174330.GE22868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110830174330.GE22868@kroah.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, Greg KH wrote:

> > > In my test system, the IDE drives are now discovered twice, once by
> > > hv_storvsc and once by libata:
> > 
> > This is a known (old problem). The way this was handled earlier was to have the 
> > modprobe rules in place to setup a dependency that would force the load of the
> > hyper-v driver (blk / stor) ahead of the native driver and if the load of the PV
> > driver succeeded, we would not load the native driver. In sles11 sp1, we had a rule for 
> > loading blkvsc. With the merge of blkvsc and storvsc, the only change we need to make
> > is to have storvsc in the rule (instaed of blkvsc).
> 
> Why do we need a rule at all?  Shouldn't the module dependancy stuff
> handle the autoloading of the drivers properly from the initrd now that
> the hotplug logic is hooked up properly?

There is no plan to load hv_vmbus (or xen-platform-pci) earlier than
native drivers.  That was the purpose of the modprobe.conf files. Now
that there is a vmbus, that fact could be checked before any other
attempt to load drivers is made and hv_vmbus should be loaded and all of
its devices have to be probed manually by modprobe `cat modulealias`.

> Or is the hotplug code not working correctly?

There is nothing to hotplug. hv_vmbus has to be loaded first so that it
can take over the devices. But it seems that there is no shutdown of the
emulated hardware, thats why the disk "sda" is shown twice.

I spot a flaw here.
KY, can hv_vmbus shutdown emulated hardware? At least the disks, because
cdroms are appearently still be handled by native drivers?

Olaf

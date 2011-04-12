Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab1DLXWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:22:44 -0400
Received: from mail.digium.com ([216.207.245.2]:58136 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab1DLXWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:22:43 -0400
Message-ID: <4DA4DEC1.1060609@digium.com>
Date: Tue, 12 Apr 2011 18:22:41 -0500
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Shepard <shep@alum.mit.edu>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc3 udevadm settle timeout, many hdb events, interrupt
 storm
References: <E1Q9j2p-0008Rr-00@www.xplot.org>
In-Reply-To: <E1Q9j2p-0008Rr-00@www.xplot.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just adding my "me too" with some comments.

On 04/12/2011 02:14 PM, Tim Shepard wrote:
> 2.6.38 is working fine on my PowerBook G4 (powerpc) and has none of
> the issues described below.
> 
> Last week I tried 2.6.39-rc2 and it hung on reboot.
> Same thing with 2.6.39-rc3 this week.
> 
> I've tracked this down to the "udevadm settle" in /etc/init.d/udev
> (from Debian squeeze).

I noticed this hang on udevadm settle too. I'm temporarily working around
it by adding udevtimeout=5 to the command line. I haven't looked into it any further.

> # udevadm monitor
> monitor will print the received events for:
> UDEV - the event which udev sends out after rule processing
> KERNEL - the kernel uevent
> 
> KERNEL[1302632376.412055] change   /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.460742] change   /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)

On my system I bisected these constant change notifications to 929e27252e
'ide: ide_requeue_and_plug() reinstate "always plug" behaviour' [1] but
haven't looked any past that.

[1] http://lkml.kernel.org/r/20110408201513.GA3040@digium.com

> I am getting over 1300 interrupts per second for ide0:

On my system, I'm not noticing anything strange here, but I'm not using the
CDROM drive:

]# cat /proc/interrupts  | grep ide && sleep 3 && cat /proc/interrupts | grep ide
 14:        100      43433        522          0   IO-APIC-edge      ide0
 15:          0          0          0          0   IO-APIC-edge      ide1
 14:        100      43469        522          0   IO-APIC-edge      ide0
 15:          0          0          0          0   IO-APIC-edge      ide1

Cheers,
Shaun

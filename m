Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab0IZCjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 22:39:17 -0400
Received: from xenotime.net ([72.52.115.56]:52295 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755956Ab0IZCjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 22:39:16 -0400
Date: Sat, 25 Sep 2010 19:39:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: James <bjlockie@lockie.ca>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: no modules :-)
Message-Id: <20100925193914.f3c919d1.rdunlap@xenotime.net>
In-Reply-To: <4C9D845A.4060105@lockie.ca>
References: <4C9D845A.4060105@lockie.ca>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Sep 2010 01:10:50 -0400 James wrote:

>  I don't like modules. :-)
> 
> What is pulling this in:
> 
> CONFIG_SCSI_WAIT_SCAN=m
> 
> I edited .config but make must have turned it back on.
> --

If you have SCSI enabled and MODULES enabled, this kconfig symbol will be
enabled (=m) automatically.  From drivers/scsi/Kconfig (with # comments):


config SCSI_WAIT_SCAN
	tristate  # No prompt here, this is an invisible symbol.
	default m
	depends on SCSI
	depends on MODULES
# scsi_wait_scan is a loadable module which waits until all the async scans are
# complete.  The idea is to use it in initrd/ initramfs scripts.  You modprobe
# it after all the modprobes of the root SCSI drivers and it will wait until
# they have all finished scanning their buses before allowing the boot to
# proceed.  (This method is not applicable if targets boot independently in
# parallel with the initiator, or with transports with non-deterministic target
# discovery schemes, or if a transport driver does not support scsi_wait_scan.)
#
# This symbol is not exposed as a prompt because little is to be gained by
# disabling it, whereas people who accidentally switch it off may wonder why
# their mkinitrd gets into trouble.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

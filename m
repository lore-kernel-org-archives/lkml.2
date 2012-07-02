Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2GBEvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:51:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:45117 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab2GBEvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:51:00 -0400
Message-ID: <1341204649.2588.29.camel@pasglop>
Subject: Re: 3.5.0-rc5: BUG: soft lockup - CPU#0 stuck for 22s
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 14:50:49 +1000
In-Reply-To: <alpine.DEB.2.01.1207010009270.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1207010009270.5568@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-01 at 00:18 -0700, Christian Kujau wrote:
> Hi,
> 
> while trying to upgrade from 3.4.0 to 3.5.0-rc5 on this Powerbook G4 
> (powerpc 32 bit), this happens during booting:
> 
> --------------
> usb 2-1: new full-speed USB device number 4 using ohci_hcd
> SCSI subsystem initialized
> scsi0 : SBP-2 IEEE-1394
> scsi1 : SBP-2 IEEE-1394
> firewire_sbp2 fw1.0: logged in to LUN 0000 (0 retries)
> scsi 0:0:0:0: Direct-Access     Ext Hard  Disk            PQ: 0 ANSI: 4

Interesting... I observed something roughly similar on a dual G4
the other day associated with a 30s to 1mn pause during boot. RCU
was complaining loudly.

In my case, it did continue booting normally, is that the case for you ?

Also if I compile the kernel without CONFIG_SMP, it did go away as well,
do you observe that too ?

I don't have a spare cycle to investigate this problem this week I'm
afraid, it might help if you could try a bisection though.

Cheers,
Ben.



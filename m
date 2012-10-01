Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2JANW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:22:28 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1501 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2JANW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:22:26 -0400
X-Greylist: delayed 652 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2012 09:22:26 EDT
Date: Mon, 1 Oct 2012 15:11:31 +0200
From: jurriaan_lkml@rivierenland.xs4all.nl
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: USB3 ports on Qnap TS-119 P II (arm, kirkwood, feroceon)
Message-ID: <20121001131131.GA3006@qnap.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a newer revision of Qnap's TS-119 P II single-bay nas. It runs an
armv5te Feroceon cpu. The older revision runs on linux 3.6-rc7 just
fine. The newer revision has usb3 ports at the back instead of usb2, and
these are not detected. lspci and lsusb detect nothing.
/sys/bus/pci/devices is empty.

Qnap provides sources for their kernel - 2.6.33.2 with lots of patches.
The usb3 ports are detected by an etxhci driver. The author of this
file, Sarah Sharp, points at pci initialization code as the likely
culprit.

The fact that Qnap's 2.6.33.2 kernel has 8800 Kb of drivers under
arch/arm/plat-feroceon that don't exist in vanilla linux agrees with
this.

Now I'm at a loss as to how to proceed. Transplanting this entire tree
under the new kernel and getting it to compile might be possible, but
vanilla linux cares about more hardware than just Qnap, and I have not
enough knowledge to determine if different Feroceon platforms are
different enough to need different drivers. I could also start upgrading
the Qnap tree with 2.6.34, 2.6.35 etc. taking small steps. 

It might also be that judicious tweaking of some PCI things (signatures?
locations?) might be enough to support these USB3 ports. 

Some more information is posted at

http://forum.qnap.com/viewtopic.php?f=147&t=61716&p=290123

including dmesg output etc.

I would really like someone experienced in either arm or pci or both to
point me at what to do next.

Thanks,
Jurriaan

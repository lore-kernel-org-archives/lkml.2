Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab2C2NeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:34:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48057 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2C2NeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:34:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 29 Mar 2012 15:34:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: David Howells <dhowells@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: On patch "Remove all #inclusions of asm/system.h"
Message-ID: <20120329153409.7295eda9@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

commit 9ffc93f2 "Remove all #inclusions of asm/system.h" removes a lot of
includes while its parent commit 96f951ed "Add #includes needed to permit
the removal of asm/system.h" adds only a few.  Some of the files modified
by commit 9ffc93f2 now only work due to indirect inclusion, don't they?

For example, drivers/firewire/{core-device,core-topology,ohci,sbp2}.c use
smp_rmb()¹ and used to include asm/system.h.  Now they do not include
asm/barrier.h.  Is this by mistake or on purpose?

(I only noticed the commit come in; I did not get any build error yet.
The mentioned files now get asm/barrier.h via linux/spinlock.h and
certainly via other ways as well.)

--------
¹) so does drivers/firewire/net.c but it missed to include asm/system.h
-- 
Stefan Richter
-=====-===-- --== ===-=
http://arcgraph.de/sr/

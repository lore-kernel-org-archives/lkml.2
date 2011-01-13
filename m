Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab1AMPo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:44:57 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:51199 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231Ab1AMPoy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:44:54 -0500
Subject: resume regression in 2.6.37
From: Sven Neumann <s.neumann@raumfeld.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Thu, 13 Jan 2011 16:44:52 +0100
Message-ID: <1294933492.2535.23.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1294933494;122b3531;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we are using devices based on an PXA300 and are successfully using the
2.6.36.2 kernel (vanilla, basically unpatched). You can find the
platform-specific code that describes our devices
in /arch/arm/mach-pxa/raumfeld.c.

Now I've tried to update the kernel to 2.6.37. After fixing the already
reported NULL pointer dereference on bootup in pxa3xx_nand_probe(), the
device seems to work fine until I suspend it and then try to wake it up
from suspend. Suspend seems to work fine, no warnings whatsoever.
However there is absolutely no sign of resume.

I've used git bisect to track this down to the following commit:


commit 2f7e99bb9be6a2d8d7b808dc86037710cc8b7bf1
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Sep 27 12:45:50 2010 +0000

    genirq: Provide compat handling for chip->set_wake()
    
    Wrap the old chip function set_wake() until the migration is
    complete and the old chip functions are removed.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Peter Zijlstra <peterz@infradead.org>
    LKML-Reference: <20100927121842.927527393@linutronix.de>
    Reviewed-by: H. Peter Anvin <hpa@zytor.com>
    Reviewed-by: Ingo Molnar <mingo@elte.hu>


Any idea on how to proceed from here? I don't think I can just revert
this commit and expect things to work, right?


Regards,
Sven


-- 
Sven Neumann
Head of RAUMFELD Software Development

Lautsprecher Teufel GmbH | Bülowstr. 66 | 10783 Berlin | Germany
Tel: +49 (0)30-300 930 153 | s.neumann@raumfeld.com


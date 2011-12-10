Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab1LJN2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 08:28:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:49304 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1LJN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 08:28:00 -0500
Message-Id: <20111210132220.083204833@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 10 Dec 2011 13:27:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>
Subject: [patch 0/3] kvm tool: Serial emulation overhaul
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We observed massive hangs of the serial console in kvm tool which
turned out to be caused by the bogus emulation of the interrupt line
behaviour.

This series cleans up and simplifies the serial code and in the last
step fixes the interrupt handling proper.

Thanks,

	tglx

 hw/serial.c               |  224 ++++++++++++++++++++--------------------------
 include/kvm/8250-serial.h |    2 
 x86/kvm.c                 |    2 
 3 files changed, 103 insertions(+), 125 deletions(-)


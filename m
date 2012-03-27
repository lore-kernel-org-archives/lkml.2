Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2C0ITI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:19:08 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41197 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2C0ITE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 27 Mar 2012 04:19:04 -0400
Message-Id: <4F719449020000780007B0CD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 27 Mar 2012 09:19:53 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <hirofumi@mail.parknet.co.jp>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: hpet_disable() call sites
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In c86c7fbc829e27e2a4093f98ded9fbd75e515adb (and subsequently
0c1b2724069951b1902373e688042b2ec382f68f) hpet_disable() gets
called in the shutdown path. The first of them gives HPET enabling
through PCI quirks in conjunction with the use of legacy replacement
as sole reason, yet even outside of the context of either the starting
up kernel has a problem if the HPET is in an unexpected state, in
particular preventing "normal" timer interrupts from occurring (which
was in particular found to be the case during kdump attempts after
Xen was running).

Is there any reason why hpet_disable() should not also be called
from (or some equivalent action be taken, perhaps including clearing
certain bits in the individual counters' configuration registers, which
are apparently - but perhaps wrongly - implied to be clear in e.g.
hpet_set_mode(), in) hpet_enable()?

Thanks, Jan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab2FFBrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 21:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab2FFBrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 21:47:12 -0400
Date: Tue, 5 Jun 2012 21:46:56 -0400
From: Dave Jones <davej@redhat.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Marc Dionne <marc.c.dionne@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120606014656.GA24870@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Francois Romieu <romieu@fr.zoreil.com>,
	Marc Dionne <marc.c.dionne@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120530214809.GA19223@redhat.com>
 <alpine.LFD.2.02.1205310938080.3231@ionos>
 <20120601225754.GA25281@electric-eye.fr.zoreil.com>
 <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com>
 <20120605231550.GA20981@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605231550.GA20981@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 01:15:50AM +0200, Francois Romieu wrote:
 > Marc Dionne <marc.c.dionne@gmail.com> :
 > > If it helps, I've been seeing the same thing here on a system with an
 > > r8169.  The message appears consistently enough on network startup to
 > > be able to track it down to this specific commit:
 > >     98ddf986fca17840e46e070354b7e2cd2169da15: r8169: bh locking redux
 > > and task scheduling.
 > > 
 > > The softirq pending messages always come right after "link down"
 > > messages for the interface.

for me, they're during boot when the nic comes up, and then very occasionally afterwards.

 > Let's see the traces.
 > 
 > I have added some code to trace the timing and values of the irq in
 > rtl8169_interrupt(). Patches against current git are attached.
 
with these patches applied, I get a lot of spew in dmesg like ..

[   98.659314] r8169 0000:01:00.0: eth0: event ring full.
[   98.763513] r8169 0000:01:00.0: eth0: event ring full.
[   99.182103] r8169 0000:01:00.0: eth0: event ring full.
[   99.294426] r8169 0000:01:00.0: eth0: event ring full.
[   99.420255] r8169 0000:01:00.0: eth0: event ring full.
[   99.455811] r8169 0000:01:00.0: eth0: event ring full.
[   99.520541] r8169 0000:01:00.0: eth0: event ring full.
[   99.730789] r8169 0000:01:00.0: eth0: event ring full.
[   99.887643] r8169 0000:01:00.0: eth0: event ring full.
[  103.798861] net_ratelimit: 43 callbacks suppressed

over and over..

 > 'ip link set dev 8168b-lom up' + 'cat /sys/kernel/debug/tracing/trace':

What tracer do I need to configure to get make this work ? irqsoff ?

finally, /sys/kernel/debug/r8169/ is empty.

	Dave


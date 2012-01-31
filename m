Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2AaNm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:42:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:51789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2AaNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:42:27 -0500
Date: Tue, 31 Jan 2012 05:43:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
Message-ID: <20120131054351.0a9f35ed@infradead.org>
In-Reply-To: <20120131125331.GE4408@elte.hu>
References: <20120130205304.0e10b05e@infradead.org>
	<20120131124341.GC4408@elte.hu>
	<1328014076.2446.210.camel@twins>
	<20120131125331.GE4408@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 13:53:32 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> 
> Wanna give a short TODO list to anyone wanting to work on that?

the biggest thing that needs to happen is splitting the hardware
specific part ("bring the chip up") and the OS specific part of
cpu_up() ("get the cpu into our accounting/awareness").

the former does not need the hotplug or any other big lock (just a state
machine), the later needs the hotplug lock for obvious reasons.
The former is the part that takes a long time (> 100msec for a first
cpu in a package, > 30msec for second and later), the later is quick.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

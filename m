Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0HBHv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:51:26 -0400
Received: from www.tglx.de ([62.245.132.106]:52592 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0HBHvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:51:21 -0400
Date: Mon, 2 Aug 2010 09:50:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.33.6-rt26: oops (network related?)
In-Reply-To: <1280602902.11380.6.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1008020940090.9198@localhost.localdomain>
References: <1280460642.2173.3.camel@localhost.localdomain> <1280602902.11380.6.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010, Fernando Lopez-Lezcano wrote:

> On Thu, 2010-07-29 at 20:30 -0700, Fernando Lopez-Lezcano wrote:
> > Hi all...
> > This may not be rt related but here it goes anyway. It happened when I
> > tried to restart my iptables service (/sbin/service iptables start). I
> > think a day or two ago I had another network related hang, but it was a
> > complete hang (no clues left behind - power button to reset). 
> 
> Ok this one is rt related (apparently). The workstation (4 core, intel
> based) hang hard while a process was starting a daily backup but the
> logs captured the BUG:
> 
> --------
> Jul 31 06:48:35 localhost kernel: ------------[ cut here ]------------
> Jul 31 06:48:35 localhost kernel: kernel BUG at kernel/rtmutex.c:808!

Weird, line 808 is a comment. The BUG_ON in rt_spin_lock_slowlock() is
at line 831.

> Jul 31 06:48:35 localhost kernel: [<c0792332>] ? rt_spin_lock+0x8/0xa
> Jul 31 06:48:35 localhost kernel: [<c075f896>] ? ipt_do_table+0xce/0x4f0

Yeah, that's the iptables locking problem, which is fixed in rt27.

Thanks,

	tglx


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0DOTwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:52:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab0DOTwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:52:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michal.simek@petalogix.com
Subject: Re: sched_clock - microblaze
Date: Thu, 15 Apr 2010 21:52:03 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: wuzhangjin@gmail.com, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <4BC728DD.5020404@petalogix.com> <1271355179.20625.107.camel@falcon> <4BC76917.9060604@petalogix.com>
In-Reply-To: <4BC76917.9060604@petalogix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004152152.03883.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX193V5zOrZ1hi+TazB2l44qvReHQy78tv2EJdmY
 q3Ksh4QzmcJzSO5NCUPzCmpsQwTAL7OERx1z5LNqfK98oHS4Vw
 BiNXeIWXMVKdMgFhSY4kQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 April 2010 21:29:27 Michal Simek wrote:
> > sched_clock() {
> >       ftrace_stop();
> >       printk(...);
> >       ftrace_start();
> >       ...
> > }
> 
> But I am describing different problem. sched_clock is called before 
> kernel initialized timers. Microblaze takes all information from DTS 
> that's means that I am not able to read timer because I even don't know 
> where it is. :-(

You could make sched_clock return zero before the clock is probed, it
is very unlikely to be needed before that anyway.

	Arnd

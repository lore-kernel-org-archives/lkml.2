Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1JAPDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 11:03:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1JAPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 11:03:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] mtd: Add DiskOnChip G3 support
Date: Sat, 01 Oct 2011 17:02:10 +0200
Message-ID: <2027446.JdsYbAItg0@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <87y5x4hpkz.fsf@free.fr>
References: <1316633266-21312-1-git-send-email-robert.jarzmik@free.fr> <201109281445.47715.arnd@arndb.de> <87y5x4hpkz.fsf@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:53Yez2IyZim0gamDuPt/xwLMMLX5waVh5f1B6CqTtz3
 00uR38FXsJeIu/jKOI9Bh210w7482AHJefvRxi1RbdqaR1YibD
 lRmmOtCjj7TQENFIaUgGGA7RSO16Kq4zZjnQZTTN+wthRftyOE
 QpL2V25HDjVQaQ5eeibWcK1LG0l3YIMQ1F8V9wzm1BXBHwSl20
 FXb7z/bJx4NWMZIJcredBAxhlSKFRRWqSxRYyDDw0eSgYc0mqS
 skN+A0g+/f7HLrBkmtL7MAXrrrEIaiUzmupuTTpf7sDADhMq1r
 0S4bhFMxDyX2d7ur49weycXIE33pVeEXvuop9EPcWJtMeA9BXQ
 jKcgmDW3jzyOdN+NHlu4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 October 2011 14:19:08 Robert Jarzmik wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> > I generally recommend removing debug messages like this entirely from
> > production code. If you need them on production systems, that is an indication
> > that the code quality is not good enough.
> Perhaps.
> But when you create a driver without any specification, and you release it to
> the communauty, there will be unmet behaviours. So, when someone will ask me
> "why in my board XXX my docg3 can't read data ?" how can I improve the driver
> without any traces ?

In my experience, the kind of debugging data you need for analysing a problem
on someone else's system is not just a trace of the commands you send to
a device but more complicated to get, so you are dependent on a clueful
bug reporter anyway.

If you have successfully debugged a remote problem just by looking at a dump,
then you should certainly leave the code in there.

> > Or you could turn the entire tracing into trace events and do the parsing
> > in user space, which seems appropriate if you frequently need to trace
> > these.
> This looks much much better. I'll have a peek into that, as only (io_address,
> read/write, width, value) could be dumped, and userland application could
> translate it into sequence/nop/flashcontrol ... etc ...

Right, that was the idea.

	Arnd

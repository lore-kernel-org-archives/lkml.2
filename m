Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1JWOHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:07:35 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5497 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560Ab1JWOHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:07:34 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p9NE6RsY005194
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Tim Bird <tim.bird@am.sony.com>,
        Joe Perches <joe@perches.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 23 Oct 2011 16:06:27 +0200
In-Reply-To: <1500345.YeXPhIIHc5@wuerfel>
References: <4E9E0B71.9020708@am.sony.com>
	 <1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com>
	 <1500345.YeXPhIIHc5@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1319378792.20227.105.camel@thorin>
Mime-Version: 1.0
X-DCC--Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2011-10-19 at 12:51 +0200, Arnd Bergmann wrote:
> On Tuesday 18 October 2011 17:26:44 Tim Bird wrote:
> > Even inside Sony, usage of 4K stacks is limited
> > to some very special cases, where memory is exceedingly
> > tight (we have one system with 4M of RAM).  And we
> > don't mind lopping off features or coding around
> > problem areas to support our special case.

Yes, for low memory situations (as in up to 8M) it is usually necessary
anyways to write every "./configure" line yourself for packages to make
sure everything possible is disabled unless it is absolutely necessary.
And a minimal custom kernel config is also unavoidable.

And then you don't have any fancy filesystems (like ext2 or some FAT
variant), loopback devices, stacking block devices or other "recursive"
parts - just a flash file system (and not necessarily that if you run
the system from the initrd which is loaded and decompressed by the boot
loader).

So all the points with "stack overflow with stacked $WHATEVER" can't
happen anyways. And in this situation one controls the user-space too,
so there won't be any obscure "root can do" issues anyways.

[ and there are more potential savings in the kernel - and user-space -
for these devices/systems. ]

> I would imagine that in those cases, you can gain more by reducing the
> number of threads in the system. What is the highest number of

If you are very limited on memory, you do this anyways: minimizing the
number of processes and threads - or better just do not use threads at
all because it also saves space.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0CYNHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:07:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0CYNHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:07:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Thu, 25 Mar 2010 14:06:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
References: <201003242240.54907.arnd@arndb.de> <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003251406.10177.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18QmkMt1FOUNb5kohZ3lrImlqloX5suNVEuyDX
 EZxGf3JB7LzeNZLtw1sM3mMkHIVZ4ZT5ljf4Ys9g9nU3bZPPsT
 W+T+H5XF1TLQmDxGsgCCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010, Jiri Kosina wrote:
> On Wed, 24 Mar 2010, Arnd Bergmann wrote:
> 
> > I've spent some time continuing the work of the people on Cc and many others
> > to remove the big kernel lock from Linux and I now have bkl-removal branch
> > in my git tree at git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
> > that lets me run a kernel on my quad-core machine with the only users of the BKL
> > being mostly obscure device driver modules.
> 
>         config USB
>                 tristate "Support for Host-side USB"
>                 depends on USB_ARCH_HAS_HCD && BKL
> 
> Well, that's very interesting definition of "obscure" :)
> 

That's why I said /mostly/ obscure modules. There are soundcore, usb-core, drm,
vfat and a few other very common ones, along with many obscure ones.

	Arnd

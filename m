Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab1FAA0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:26:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:42406 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986Ab1FAAZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:25:59 -0400
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 10:25:42 +1000
Message-ID: <1306887942.29297.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 16:50 -0700, Christian Kujau wrote:
> Hi,
> 
> trying to boot 3.0-rc1 on powerpc32 only progresses until:
> 
>   > Kernel virtual memory layout:
>   >   * 0xfffcf000..0xfffff000  : fixmap
> 
> And then the system hangs, does not respond to keyboard (sysrq does not 
> seem to work on this PowerBook G4). But after a while the system reboots 
> itself, so I guess the machine panicked but did not print anything on the 
> screen.
> 
> Full messages (picture), config & (working) dmesg:
> 
>    http://nerdbynature.de/bits/3.0-rc1/
> 
> I'm currently trying to bisect this, so far I have:

Hrm, I had it working on a pair of powerbooks yesterday. Can you try
something like "udbg-immortal" on your kernel command line to see if
that makes a difference in the output ?

Cheers,
Ben.

> ----------------------
> git bisect start
> # good: [61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf] Linux 2.6.39
> git bisect good 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf
> # bad: [55922c9d1b84b89cb946c777fddccb3247e7df2c] Linux 3.0-rc1
> git bisect bad 55922c9d1b84b89cb946c777fddccb3247e7df2c
> # bad: [c44dead70a841d90ddc01968012f323c33217c9e] Merge branch 'usb-next' 
> of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
> git bisect bad c44dead70a841d90ddc01968012f323c33217c9e
> # bad: [d93515611bbc70c2fe4db232e5feb448ed8e4cc9] macvlan: fix panic if 
> lowerdev in a bond
> git bisect bad d93515611bbc70c2fe4db232e5feb448ed8e4cc9
> ----------------------
> 
> Any ideas?
> 
> Thanks,
> Christian.



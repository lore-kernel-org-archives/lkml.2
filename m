Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1BLOuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 09:50:20 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:56994 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab1BLOuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 09:50:16 -0500
X-Greylist: delayed 1293 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Feb 2011 09:50:16 EST
From: Florian Weimer <fw@deneb.enyo.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: martin capitanio <m@capitanio.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: mmap, the language go, problems with the linux kernel
References: <1297168678.2190.21.camel@marvin>
	<20110208132657.1cf55782@lxorguk.ukuu.org.uk>
Date: Sat, 12 Feb 2011 15:28:37 +0100
In-Reply-To: <20110208132657.1cf55782@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Tue, 8 Feb 2011 13:26:57 +0000")
Message-ID: <87sjvtba3u.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox:

> Linux implements virtual address space limits, and enforces them. The go
> language stuff wants to allocate huge amounts of virtual space so you
> need to tell the OS you want to allow it to do crazy stuff, which you can
> do so. But virtual address space is not free - it has to be tracked and
> if the application suddenely tries to fill all of it what will happen ?
>
> You'll hit problems if the kernel is running with vm overcommit disabled
> (as well configured servers do),

The odd thing is that prot==0 does *not* count against the
vm.overcommit_memory=2 limit, only against ulimit -v.  The limit is
only enforced for the parts on which mprotect is called.  I think this
should really be part of the public API (I'm not sure if it is right
now, it could well be an accident), to avoid the problems you
describe.

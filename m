Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1A1Axl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:53:41 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:35940 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1A1Axk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:53:40 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Jan 2011 16:53:39 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
cc: uClibc <uclibc@uclibc.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: timerfd incompatibility on mips
In-Reply-To: <20110128032443.6f8b877e@apollo.gnet>
Message-ID: <alpine.DEB.2.00.1101271651250.30861@localhost6.localdomain6>
References: <20110128032443.6f8b877e@apollo.gnet>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011, Alexander Gordeev wrote:

> Hi!
> 
> I've just found a problem with TFD_NONBLOCK flag that can be passed to
> timerfd_create.
> 
> <uclibc>/libc/sysdeps/linux/common/sys/timerfd.h which is installed
> to /usr/include/sys/timerfd.h defines TFD_NONBLOCK as 04000 ie 0x800.
> BTW glibc/eglibc headers do the same thing.
> 
> <linux>/include/linux/timerfd.h declares it as O_NONBLOCK which is
> defined in fcntl.h. Usually O_NONBLOCK is 0x800 too but some
> architectures including MIPS it redefine it:
> 
> arch/mips/include/asm/fcntl.h:#define O_NONBLOCK	0x0080
> arch/alpha/include/asm/fcntl.h:#define O_NONBLOCK	00004
> arch/sparc/include/asm/fcntl.h:#define O_NONBLOCK	0x4000
> arch/parisc/include/asm/fcntl.h:#define O_NONBLOCK	000200004
> 
> My tests show that kernel thinks that TFD_NONBLOCK is 0x80 on MIPS. I
> get what I want when I pass 0x80 and EINVAL when I pass 0x800. I don't
> know why there are such uncertain things in Linux. Probably the problem
> should be fixed in the kernel.
> 
> Right now one cannot use timerfd_create(..., TFD_NONBLOCK) on MIPS but
> can use timerfd_create(..., O_NONBLOCK) instead.

Ther kernel definition (include/linux/timerfd.h) maps it directly to 
O_NONBLOCK, but I am noticing that glibc bolt in the value.
I don't think this is a kernel fix.


- Davide



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2D0Uxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:53:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2D0Uxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:53:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Date: Fri, 27 Apr 2012 20:52:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Mike Frysinger <vapier@gentoo.org>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <20120427171433.GE14743@mudshark.cambridge.arm.com> <4F9ADD22.70003@zytor.com>
In-Reply-To: <4F9ADD22.70003@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204272052.34489.arnd@arndb.de>
X-Provags-ID: V02:K0:FNdVm78rNmheGkcL1q8kB/GHLK4cSzQYj2AXynr4Woa
 0AJ2ehAYLVcBzktgzS9Ob4dmRvljusaZUo9H55lroyVr+HTWRW
 ocJZ8YA9otH8mxqEiHX8Y6uAJGHTJfIpMhlKnDUTs6WCRKVU/6
 EX1hvZ0XyU7BQDA08WnYyrOOYVmSYONvYOgjJWasoAdw4rSo/7
 xStkj/0GsUZHEryPbhkDvgtzecDdWE2BBsAX9DJhbeSJCoPSA9
 JRSI92RQRYRHu/mEkii99QpVK5Ly/qJr64AThk14281bE934Tu
 suJ3r+66KG15lvgS8YrRZW3NMukuLWW5QJpH/5ER44QC6Ignuz
 nnzg3tS7XSgCa+QoYrLk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2012, H. Peter Anvin wrote:
> On 04/27/2012 10:14 AM, Will Deacon wrote:
> > 
> > If you remove the architecture-specific drivers, there's really not a lot left
> > and, even then, we only need to convert those drivers which are intended to
> > be portable between architectures where the string functions are not
> > consistently available.
> > 
> > By overheads, I assume you're referring to the IO_COND check on the address
> > space? I wouldn't expect this to be noticeable compared to the cost of the
> > I/O access and I'm not sure it's worth worrying about for the sake of the
> > small number of drivers affected.
> > 
> 
> It's not in time, but it adds bulk to the code.  The point is that what
> is the benefit of not making these part of the general API?  For
> architectures where the address space doesn't matter they could just
> alias it to the same functions, or use the generic versions.
> 

The main reasons I can see for not making it a general purpose API are:

* It's a very confusing interface, because the endianess rules are different
  from the non-string variants and counterintuitive.

* Almost all the users are ancient ARM specific drivers, the others are
  either new ARM specific drivers or drivers that started out as ARM-only
  and were ported later to other architectures (sh, avr32, mips, mn10300
  and blackfin)

* On all these architectures, the PCI I/O space is memory mapped (or
  non-existent), so the ioread* functions are trivial wrappers without
  additional overhead.

* Most architectures don't implement them today, but all architectures
  that support MMIO also implement the ioread string operations.

	Arnd

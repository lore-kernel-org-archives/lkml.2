Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2IJNxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:53:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab2IJNxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:53:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Date: Mon, 10 Sep 2012 13:53:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <20120910055339.GC31430@game.jcrosoft.org> <20120910125137.GC27042@arm.com>
In-Reply-To: <20120910125137.GC27042@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101353.34325.arnd@arndb.de>
X-Provags-ID: V02:K0:n7C225yDkWMnb2Azt/HBIfA8+gRG+66a9UCk4rGvEdM
 F57OqxfISA4SOJPZSaXjGuZ2U1gohrxKLW8G0FCw4TlSoo3681
 T3YGGpZU75kGTYJlTaQI5xWlr0M61hcxJxz+UG6WsbcSK3CJz8
 4+nOxEO+V90pOJA4lGC3yHVqfdFQFSgZnDnnjwQjSS7m0DtJKu
 8pi1sxE184FI+t99KATgVOt5E9U4lByXsflCUDzpb7Vu3BsGEO
 wOKGx6CzZ1DFSFsA0Cvz2Ix/WOSxWCjkYhlmxOSNuNTGAh7JqF
 TK6loapNmMh5zYcetFvOKOXJ8u1MQE/UeI8CyYjpM3lXlnLEYn
 rfFzdxQ9cAyxV7Kwlpc8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2012, Catalin Marinas wrote:
> On Mon, Sep 10, 2012 at 06:53:39AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 19:29 Sun 09 Sep     , Nicolas Pitre wrote:
> > > On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > > On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
> > > > > +The image must be placed at the specified offset (currently 0x80000)
> > > > > +from the start of the system RAM and called there. The start of the
> > > > > +system RAM must be aligned to 2MB.
> > > > can we drop this
> > > 
> > > Drop what?
> > > And why?
> > This contrain the must be loadable at any address
> 
> You can't easily load the kernel image at any address, unless it can
> relocate itself and you have a way to specify PHYS_OFFSET. We don't want
> a compile-time PHYS_OFFSET, the kernel detects it at boot time based on
> the load address.

I think a bunch of other architectures can have relocatable kernels, which
is useful e.g. for kdump. It does imply a small runtime cost and may have
other disadvantages though.

	Arnd

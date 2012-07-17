Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2GQHJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:09:41 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:59765 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2GQHJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:09:39 -0400
Message-ID: <50050FA9.5090608@jonmasters.org>
Date: Tue, 17 Jul 2012 03:09:29 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com> <20120710101018.GE15120@arm.com> <20120714093032.GA23316@elf.ucw.cz> <20120715121644.GB10597@arm.com> <5003CFBA.3060108@redhat.com>
In-Reply-To: <5003CFBA.3060108@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 04:24 AM, Avi Kivity wrote:

> Can the same kernel image run in both EL1 and EL2?  I noticed some .if
> ELs in the assembler files.  I guess they could be compiled multiple
> times and the correct version chosen at runtime, or patched up like x86
> does with alternative().

> One of the advantages kvm has to Linux distributors is that the same
> kernel image can be used the hypervisor, guest, and bare metal.  I'd
> like to preserve that for arm64.

The idea is that you would always enter at EL2 and then drop privilege
down to EL1 if you're not doing virt. That achieves effectively the same
thing that you get on x86. The virtualization in AArch64 is designed
more from the POV of separate hypervisors like Xen so we just need to
make sure we always start with enough privilege.

Jon.

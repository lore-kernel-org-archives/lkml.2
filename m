Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0FLUEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 16:04:52 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:48346 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0FLUEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 16:04:51 -0400
Message-ID: <1276373081.4c13e859a61fc@imp.free.fr>
Date: Sat, 12 Jun 2010 22:04:41 +0200
From: castet.matthieu@free.fr
To: linux-kernel@vger.kernel.org
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:x86/mm] x86, mm: Set first MB as RW+NX
References: <1276360709.4c13b80507f8b@imp.free.fr>
In-Reply-To: <1276360709.4c13b80507f8b@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 81.57.151.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selon castet.matthieu@free.fr:

> hi,
>
> > Special accommodations have been made for BIOS32/PCI BIOS services:
> > according to BIOS32 specification
> > (http://members.datafast.net.au/dft0802/specs/bios32.pdf), at most two
> > pages per BIOS32 service should be set executable and no pages need to
> > be writeable.
> From my understanding only the service directory take 2 pages.
>
> The no info for the pci service :
> - the length field could be used to find the number of page it takes.
> - could we assume data ro ?
>

http://members.datafast.net.au/dft0802/specs/bios21.pdf got all info for pci
bios [1].
So I was right : we shouldn't assume pci bios routine take only 2 pages, but use
the length parameter.


Matthieu



[1]
The 32-bit PCI BIOS functions must be accessed using CALL FAR. The CS and DS
descriptors must be setup to encompass the physical addresses specified by the
Base and
Length parameters returned by the BIOS32 Service Directory. The CS and DS
descriptors must have the same base. The calling environment must allow access
to IO
space and provide at least 1K of stack space. Platform BIOS writers must assume
that CS
is execute-only and DS is read-only.

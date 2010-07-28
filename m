Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0G1PFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:05:38 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:52030 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0G1PFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:05:36 -0400
X-IronPort-AV: E=Sophos;i="4.55,274,1278288000"; 
   d="scan'208";a="1115934"
Date: Wed, 28 Jul 2010 16:06:26 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: linux-next: Tree for July 27 (xen)
In-Reply-To: <4C504345.2050204@goop.org>
Message-ID: <alpine.DEB.2.00.1007281601380.19809@kaball-desktop>
References: <20100727160708.722c39c1.sfr@canb.auug.org.au> <4C4F27A3.5040109@oracle.com> <alpine.DEB.2.00.1007281410030.19809@kaball-desktop> <4C504345.2050204@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010, Jeremy Fitzhardinge wrote:
>   On 07/28/2010 06:11 AM, Stefano Stabellini wrote:
> > On Tue, 27 Jul 2010, Randy Dunlap wrote:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20100726:
> >>>
> >>>
> >>> The xen tree lost its build problems but gained a conflict against Linus'
> >>> tree.
> >> when X86_32=y, SMP=n, X86_LOCAL_APIC=n:
> >>
> >> drivers/built-in.o: In function `xen_callback_vector':
> >> (.text+0x41238): undefined reference to `first_system_vector'
> >>
> >> alloc_intr_gate() calls alloc_system_vector(), which uses first_system_vector.
> > this patch should solve the issue:
> 
> So this is a generic x86 build problem?
> 

It is, but nobody else is calling alloc_intr_gate with X86_LOCAL_APIC=n;
being a static inline function it didn't cause any problems.


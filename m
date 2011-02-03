Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1BCHq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 02:46:59 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43878 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab1BCHq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 02:46:58 -0500
Date: Thu, 3 Feb 2011 08:47:58 +0100
From: Borislav Petkov <bp@amd64.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110203074758.GA23561@aftab>
References: <4D461FB9.5050807@goop.org>
 <20110131070241.GA22071@liondog.tnic>
 <4D46FC9F.6090309@goop.org>
 <20110131234131.GA16095@liondog.tnic>
 <4D475099.1080004@goop.org>
 <4D475DB5.1020300@zytor.com>
 <4D488EB1.9020803@goop.org>
 <4D49B5F6.5010606@zytor.com>
 <4D49B903.2080602@goop.org>
 <20110203005517.GA30220@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203005517.GA30220@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 10:55:17PM -0200, Henrique de Moraes Holschuh wrote:
> It would not be much of a problem to add AMD support to it as well (or write
> a separate tool), just point me to a friendly AMD engineer that will supply
> the docs (or point me to them if they're already public), vouch for the fact
> that we're allowed to unpack/merge/strip/repack AMD microcode packs, and
> test the tool, because I have no AMD boxes at home or at work to test it.

We already have a single container file with all the ucode patches in
it: http://www.amd64.org/support/microcode.html and the microcode driver
in the kernel can look at it and take out the patches it needs based on
the CPU it is running on. Is that what you had in mind?

> > My main concern is that I want Xen to Just Work - ideally by not
> > requiring users/admins to do anything.
> 
> I have no experience with Xen.  What do I get from cpuid(0) and cpuid(1) in
> dom0 when the bare metal uses Intel CPUs?  And AMD CPUs?   I'd like to teach
> the tool to not do anything idiotic under Xen...

Actually, if the microcode image can be provided to the hypervisor early
using multiboot, it should be easy for it to figure out on what hardware
it is running and apply the correct microcode without the need for dom0
to know anything about microcode, IMHO.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

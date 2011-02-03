Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1BCQFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:05:30 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39242 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab1BCQF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:05:28 -0500
X-Sasl-enc: iMxzUw+KKSvUnB/8gCzvfHPKmTy0Np4Qbt1dyPZhzcir 1296749126
Date: Thu, 3 Feb 2011 14:05:21 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110203160521.GA29349@khazad-dum.debian.net>
References: <20110131070241.GA22071@liondog.tnic>
 <4D46FC9F.6090309@goop.org>
 <20110131234131.GA16095@liondog.tnic>
 <4D475099.1080004@goop.org>
 <4D475DB5.1020300@zytor.com>
 <4D488EB1.9020803@goop.org>
 <4D49B5F6.5010606@zytor.com>
 <4D49B903.2080602@goop.org>
 <20110203005517.GA30220@khazad-dum.debian.net>
 <20110203074758.GA23561@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203074758.GA23561@aftab>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Feb 2011, Borislav Petkov wrote:
> On Wed, Feb 02, 2011 at 10:55:17PM -0200, Henrique de Moraes Holschuh wrote:
> > It would not be much of a problem to add AMD support to it as well (or write
> > a separate tool), just point me to a friendly AMD engineer that will supply
> > the docs (or point me to them if they're already public), vouch for the fact
> > that we're allowed to unpack/merge/strip/repack AMD microcode packs, and
> > test the tool, because I have no AMD boxes at home or at work to test it.
> 
> We already have a single container file with all the ucode patches in
> it: http://www.amd64.org/support/microcode.html and the microcode driver
> in the kernel can look at it and take out the patches it needs based on
> the CPU it is running on. Is that what you had in mind?

Validate the container file in userspace, let the user list available
microcode updates, let the user merge multiple container files into a new
one with just the most up-to-date microcodes for each CPU, optionally
filtered for the CPUs currently online, or to the ones specificed in the
command line.

I have a tool that does that for Intel, based on their documentation and
also on the Linux driver.

However, since AMD has so few microcodes in that file and it is so small,
that's probably not useful at all right now.  Maybe in a few years :-)

> > > My main concern is that I want Xen to Just Work - ideally by not
> > > requiring users/admins to do anything.
> > 
> > I have no experience with Xen.  What do I get from cpuid(0) and cpuid(1) in
> > dom0 when the bare metal uses Intel CPUs?  And AMD CPUs?   I'd like to teach
> > the tool to not do anything idiotic under Xen...
> 
> Actually, if the microcode image can be provided to the hypervisor early
> using multiboot, it should be easy for it to figure out on what hardware
> it is running and apply the correct microcode without the need for dom0
> to know anything about microcode, IMHO.

I'd still appreciate that information.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

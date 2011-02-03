Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab1BCAzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:55:22 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50351 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab1BCAzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:55:21 -0500
X-Sasl-enc: MDva/a1c6SromxkqfE7Onrg2lzxxq/2NjMj7D8hXryAd 1296694520
Date: Wed, 2 Feb 2011 22:55:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110203005517.GA30220@khazad-dum.debian.net>
References: <20110130113356.GA27967@liondog.tnic>
 <4D461FB9.5050807@goop.org>
 <20110131070241.GA22071@liondog.tnic>
 <4D46FC9F.6090309@goop.org>
 <20110131234131.GA16095@liondog.tnic>
 <4D475099.1080004@goop.org>
 <4D475DB5.1020300@zytor.com>
 <4D488EB1.9020803@goop.org>
 <4D49B5F6.5010606@zytor.com>
 <4D49B903.2080602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D49B903.2080602@goop.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Feb 2011, Jeremy Fitzhardinge wrote:
> work with that.  That principally means getting the microcode images
> into /boot in a pre-digested form (binary, not text, and maybe pack the
> Intel and AMD files together in some extensible way - or at least give
> them self-describing headers).

I can get you a tool to manipulate the Intel microcode packs, and output
them in binary format.  I was planning to eventually switch Debian to it
anyway, as microcode.ctl is slow and unsuitable for initramfs use, and it is
high time we junked it.  The tool is somewhat messy, and I am pretty sure my
messy C is not going to get any good taste awards, but it works.

I will just remove support for /lib/firmware/intel-ucode/* from it before
making it public, because I want that hideously bad idea to DIE and it would
be counter-productive to actually create users for it (AFAIK, nobody ever
used /lib/firmware/intel-ucode/*, so we could still fix it).

But I'd really, really appreciate if someone from Intel [that actually cares
for operating system support of microcode updates] could vouch that we're
allowed to do that (convert their text packs to binary packs, merge
microcodes from older packs with the new to have a single pack with all
microcodes in their most up-to-date revision, and distribute the resulting
binary packs) before I make the tool public.

It would not be much of a problem to add AMD support to it as well (or write
a separate tool), just point me to a friendly AMD engineer that will supply
the docs (or point me to them if they're already public), vouch for the fact
that we're allowed to unpack/merge/strip/repack AMD microcode packs, and
test the tool, because I have no AMD boxes at home or at work to test it.

> My main concern is that I want Xen to Just Work - ideally by not
> requiring users/admins to do anything.

I have no experience with Xen.  What do I get from cpuid(0) and cpuid(1) in
dom0 when the bare metal uses Intel CPUs?  And AMD CPUs?   I'd like to teach
the tool to not do anything idiotic under Xen...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

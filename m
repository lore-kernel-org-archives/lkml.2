Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1JLVka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:40:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51531 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab1JLVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:40:26 -0400
Date: Wed, 12 Oct 2011 23:40:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20111012214013.GD28723@aftab>
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com>
 <4E94E1E5.4070505@goop.org>
 <20111012101615.GA14966@aftab>
 <4E95D9E7.6090304@zytor.com>
 <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
 <20111012204048.GA22260@phenom.oracle.com>
 <4E960746.90805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E960746.90805@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 05:31:50PM -0400, H. Peter Anvin wrote:
> On 10/12/2011 01:40 PM, Konrad Rzeszutek Wilk wrote:
> > Why is it paramount to do it as early as possible? As in, even doing
> > it before Linux kernel is invoked is preferred than during initrd runtime?
> 
> It is paramount to do it as early as possible *because the CPU is 
> broken*.  That's why there is a microcode update at all.  It is 
> *supposed* to be installed by BIOS, but for whatever reason it wasn't 
> (including user doesn't want to update the BIOS), so the very fact that 
> this is done in the OS at all is a bit of a fail.

Oh, that's easy: you know how OEMs support a platform for a while and
then move on to something new and stop updating BIOSen, including ucode
images contained in them?

Well, in that case, the OS is the last possible place where we want to
be able to apply the ucode. And, we want to apply it as _early_ _as_
_possible_. Bootloader doesn't cut it as hpa says below, so next comes
SMP cores bootup code. That's it.

> Doing it in the bootloader is messy because bootloaders typically
> aren't SMP-aware (and really shouldn't need to be), which leaves the
> OS. On native hardware it should ideally be done as early in the
> processor bringup as possible.

Yep.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

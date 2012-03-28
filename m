Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab2C1R1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:27:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57924 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab2C1R1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:27:54 -0400
Date: Wed, 28 Mar 2012 19:27:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Trevor Turner <turn3r.tr3v0r@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
Message-ID: <20120328172759.GC6765@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Trevor Turner <turn3r.tr3v0r@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
 <20120328111957.GA6765@x1.osrc.amd.com>
 <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com>
 <20120328171059.GA7919@x1.osrc.amd.com>
 <4F7346BB.9020907@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F7346BB.9020907@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 10:13:31AM -0700, Randy Dunlap wrote:
> > in your config. K7 and EFI are from different epochs anyway and cannot
> > obviously be enabled both on the same system with the current Kconfig
> > for EFI.

> but the Kconfig files shouldn't allow such a failing .config to be
> created, or the Makefiles are inadequate, or <mumble something>....

Yeah, something like the following:

config MK7
	bool "Athlon/Duron/K7"
	depends on X86_32 && !EFI_STUB

or the other way around:

config EFI_STUB
       bool "EFI stub support"
       depends on EFI && !MK7

Hmm...

-- 
Regards/Gruss,
Boris.

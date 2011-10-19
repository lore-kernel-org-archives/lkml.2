Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1JSSMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:12:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54034 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1JSSMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:12:02 -0400
Date: Wed, 19 Oct 2011 20:11:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        EDAC devel <linux-edac@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] x86, RAS: Start reorganizing RAS features support
Message-ID: <20111019181141.GA6346@aftab>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
 <1319035866-29570-3-git-send-email-bp@amd64.org>
 <987664A83D2D224EAE907B061CE93D5301F19DBDB5@orsmsx505.amr.corp.intel.com>
 <4E9F0753.1010206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9F0753.1010206@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 01:22:27PM -0400, Mauro Carvalho Chehab wrote:
> Em 19-10-2011 15:13, Luck, Tony escreveu:
> >> Start relocating RAS features into a centralized location under
> >> arch/x86/kernel/cpu/ras/. Readjust Kconfig items and makefiles
> >> accordingly.
> > 
> > Not all ras features are "cpu" orientated ... should we really be
> > moving to "arch/x86/kernel/ras"?
> 
> I think that it makes sense to move MCA bits into arch/x86, but I agree
> with Tony: generally speaking, RAS is not even x86 specific.

But we are :-)

> It seems to make more sense to rename drivers/edac to drivers/ras and put
> the RAS menu there, even if the actual support for the AMD and Intel MCA
> RAS stuff is kept inside arch/x86/...

drivers/edac/ contains other architectures too, patches for which we
cannot (and probably don't want to) test so the whole deal has to be
x86-centric.

I don't consider MCE decoding and injection drivers but rather MCA
functionality extensions or something, so those should go to arch/x86/
IMHO.

And the DRAM error decoding things, aka EDAC, should stay where they
are, although I cannot call them real drivers, either. We can't move
them yet anyway because they use the whole EDAC infrastructure.

Hmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

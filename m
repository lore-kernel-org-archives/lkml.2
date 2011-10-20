Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1JTPMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:12:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41993 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1JTPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:12:08 -0400
Date: Thu, 20 Oct 2011 17:12:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] x86, RAS: Start reorganizing RAS features support
Message-ID: <20111020151206.GI12080@aftab>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
 <1319035866-29570-3-git-send-email-bp@amd64.org>
 <987664A83D2D224EAE907B061CE93D5301F19DBDB5@orsmsx505.amr.corp.intel.com>
 <4E9F0753.1010206@redhat.com>
 <20111019181141.GA6346@aftab>
 <4E9F2180.6030207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9F2180.6030207@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 03:14:08PM -0400, Mauro Carvalho Chehab wrote:
> > I don't consider MCE decoding and injection drivers but rather MCA
> > functionality extensions or something, so those should go to arch/x86/
> > IMHO.
> 
> Agreed. MCE decoders and MCE error injection fit better together with
> MCA bits. I think they could just be moved to be into the same directory where 
> the MCE driver is located.

I think you mean arch/x86/kernel/cpu/mcheck/. Well, that _is_ possible,
since they're MCA extensions.

> > And the DRAM error decoding things, aka EDAC, should stay where they
> > are, although I cannot call them real drivers, either. We can't move
> > them yet anyway because they use the whole EDAC infrastructure.
> 
> True.
> 
> From someone that wants to select the RAS features however, it makes sense 
> to put everything together at the same menu when selecting the RAS options.
> 
> There are some tricks that could be used, like, for example, having something
> like:
> 
> menuconfig RAS_FEATURES
> 	bool "Enable RAS features"
> 
> if RAS_REATURES
> 
> config RAS_MCE
> 	bool "turn on Memory Channel Architecture Error logic for AMD CPU's"
> 	depends on X86
> 	select X86_MCE_AMD
> 
> config RAS_MCE
> 	bool "turn on Memory Channel Architecture Error logic for Intel CPU's"
> 	depends on X86
> 	select X86_MCE_INTEL
> 
> source "drivers/edac"
> 
> endif
> 
> at a /drivers/ras Kconfig (or at /ras)
> 
> This would allow putting everything together at the same Kconfig menu.

Ok, we could do that too, it has merits.

Let's discuss all this at KS.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0EaNva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:51:30 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:10279 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0EaNv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:51:28 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz1432P98dNzz1202hzz3198r327alz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L3AEHI-01-FDM-02
X-M-MSG: 
Date: Mon, 31 May 2010 15:51:32 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jeff Dike <jdike@addtoit.com>
CC: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100531135132.GA4915@aftab>
References: <201005271944.09541.toralf.foerster@gmx.de>
 <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
 <20100530150214.GA1565@liondog.tnic>
 <201005301728.25976.toralf.foerster@gmx.de>
 <20100530170346.GC1565@liondog.tnic>
 <4C02B020.2040103@zytor.com>
 <20100530193956.GA2498@liondog.tnic>
 <20100531023212.GA22673@c-98-229-117-200.hsd1.ma.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100531023212.GA22673@c-98-229-117-200.hsd1.ma.comcast.net>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>
Date: Sun, May 30, 2010 at 10:32:12PM -0400

> On Sun, May 30, 2010 at 09:39:56PM +0200, Borislav Petkov wrote:
> > Which begs the question why _is_ UML sucking in x86 stuff and can anyone
> > provide us with some sensible reasons? Because if there aren't any, it
> > is their includes that should be fixed. Let me see what I can do to
> > redirect hweight stuff properly...
> 
> Generally, UML pulls in the host arch headers because they work.  When
> they are only architecture-dependent (and not, say, depending on the
> host task struct or something), they're fine.
> 
> What's the include path from UML to the x86 hweight stuff?

<arch/x86/include/asm/bitops.h> includes <asm/arch_hweight.h> which are
the optimized variants.

I have a patch which with which UML falls back to the defaults:
http://marc.info/?l=linux-kernel&m=127525067908139&w=2 but hpa's concern
is still valid: UML shouldn't choke on the optimized variants. Anyways,
here's the original commit d61931d89be506372d01a90d1755f6d0a9fafe2d -
you might be able to find something which interferes with UML in there.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.


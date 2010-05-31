Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab0EaQ3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:29:40 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:30890
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756409Ab0EaQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:29:38 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432P98dNzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L3ALT3-01-L4L-02
X-M-MSG: 
Date: Mon, 31 May 2010 18:29:38 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jeff Dike <jdike@addtoit.com>
CC: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100531162938.GA6574@aftab>
References: <201005271944.09541.toralf.foerster@gmx.de>
 <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
 <20100530150214.GA1565@liondog.tnic>
 <201005301728.25976.toralf.foerster@gmx.de>
 <20100530170346.GC1565@liondog.tnic>
 <4C02B020.2040103@zytor.com>
 <20100530193956.GA2498@liondog.tnic>
 <20100531023212.GA22673@c-98-229-117-200.hsd1.ma.comcast.net>
 <20100531135132.GA4915@aftab>
 <20100531155619.GA29244@c-98-229-117-200.hsd1.ma.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100531155619.GA29244@c-98-229-117-200.hsd1.ma.comcast.net>
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
Date: Mon, May 31, 2010 at 11:56:19AM -0400

> On Mon, May 31, 2010 at 03:51:32PM +0200, Borislav Petkov wrote:
> > <arch/x86/include/asm/bitops.h> includes <asm/arch_hweight.h> which are
> > the optimized variants.
> 
> But how does UML get to arch/x86/include/asm/bitops.h in the first place?
> 
> It must go through an arch/um/include/asm/something.h (where something
> might be bitops) first, right?

Right, look at one of those dependencies file (for example,
arch/um/kernel/.ptrace.o.cmd) for a _very_ long inclusion chain which
contains <arch/x86/include/asm/arch_hweight.h> at some point.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.


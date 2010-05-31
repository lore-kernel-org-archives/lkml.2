Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0EaOLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:11:00 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:34455
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755065Ab0EaOK6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:10:58 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz1432Pab9bhzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L3AFDW-02-G9K-02
X-M-MSG: 
Date: Mon, 31 May 2010 16:10:58 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
CC: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100531141058.GB4915@aftab>
References: <201005271944.09541.toralf.foerster@gmx.de>
 <20100530193956.GA2498@liondog.tnic>
 <20100530201738.GB2498@liondog.tnic>
 <201005311555.56791.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <201005311555.56791.toralf.foerster@gmx.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toralf Förster <toralf.foerster@gmx.de>
Date: Mon, May 31, 2010 at 09:55:53AM -0400

> Borislav Petkov wrote at 22:17:38
> > LKML-Reference: <201005271944.09541.toralf.foerster@gmx.de>
> > Signed-off-by: Borislav Petkov <bp@alien8.de>
> > ---
> >  arch/um/include/asm/arch_hweight.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/um/include/asm/arch_hweight.h
> > 
> > diff --git a/arch/um/include/asm/arch_hweight.h b/arch/um/include/asm/arch_hweight.h
> > new file mode 100644
> > index 0000000..c656cf4
> > --- /dev/null
> > +++ b/arch/um/include/asm/arch_hweight.h
> > @@ -0,0 +1,6 @@
> > +#ifndef _ASM_UM_HWEIGHT_H
> > +#define _ASM_UM_HWEIGHT_H
> > +
> > +#include <asm-generic/bitops/arch_hweight.h>
> > +
> > +#endif
> > 
> This patch does not to solve the reported issue by me.

Did you do 'make mrproper' before rebuilding UML with it?

Also, can you do

grep -EriIn 'x86.*hweight\.h' arch/um/

after having applied the patch?

You shouldn't be getting any matches. If it still fails then, then it is
something else since with this patch, UML includes the standard hweight*
routines.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.


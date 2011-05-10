Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1EJFO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 01:14:57 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43988 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1EJFO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 01:14:56 -0400
Date: Tue, 10 May 2011 07:14:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Borislav Petkov <bp@amd64.org>, EDAC devel <linux-edac@vger.kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/6] x86, MCE: Add a HW injection flag
Message-ID: <20110510051422.GA14195@aftab>
References: <1304966155-9841-1-git-send-email-bp@amd64.org>
 <1304966155-9841-2-git-send-email-bp@amd64.org>
 <4DC8B117.9030302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC8B117.9030302@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 11:29:27PM -0400, Hidetoshi Seto wrote:
> (2011/05/10 3:35), Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Add an mce->inject_flag to denote that we're doing HW injection.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/include/asm/mce.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> > index eb16e94..a2e3dcf 100644
> > --- a/arch/x86/include/asm/mce.h
> > +++ b/arch/x86/include/asm/mce.h
> > @@ -49,6 +49,7 @@
> >  #define MCJ_CTX_IRQ		2    /* inject context: IRQ */
> >  #define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
> >  #define MCJ_EXCEPTION		8    /* raise as exception */
> > +#define MCJ_HW_INJECT		16   /* do a HW MCE inject, i.e. INT18 */
> >  
> >  /* Fields are zero when not available */
> >  struct mce {
> 
> IMHO, we should have better name for this feature; using wrmsr + int$18 is not
> the only way to inject mce event to HW. I'd like to suggest MCJ_AMD_HW_INJECT,
> MCJ_USE_WRMSR or so instead. Then we can have MCJ_USE_APEI_EINJ and so on, for
> various way of MCE injection.

Fair enough, the name might be too generic. Maybe I should change it to
MCJ_HW_MSR_INJECT to denote injecting of hw errors through the MCA MSRs.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

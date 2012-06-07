Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2FGHVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:21:37 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48335 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2FGHVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:21:35 -0400
Date: Thu, 7 Jun 2012 09:21:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Borislav Petkov <bp@amd64.org>, Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] x86, AMD: Fix crash as Xen Dom0 on AMD Trinity
 systems
Message-ID: <20120607072159.GB9856@aftab.osrc.amd.com>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
 <1338562358-28182-4-git-send-email-bp@amd64.org>
 <4FCFD2EE.8060508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCFD2EE.8060508@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 03:00:14PM -0700, H. Peter Anvin wrote:
> On 06/01/2012 07:52 AM, Borislav Petkov wrote:
> > From: Andre Przywara <andre.przywara@amd.com>
> > 
> > f7f286a910221 ("x86/amd: Re-enable CPU topology extensions in case BIOS
> > has disabled it") wrongfully added code which used the AMD-specific
> > {rd,wr}msr variants for no real reason.
> > 
> > This caused boot panics on xen which wasn't initializing the
> > {rd,wr}msr_safe_regs pv_ops members properly.
> > 
> > This, in turn, caused a heated discussion leading to us reviewing all
> > uses of the AMD-specific variants and removing them where unneeded
> > (almost everywhere except an obscure K8 BIOS fix, see 6b0f43ddfa358).
> > 
> > Finally, this patch switches to the standard {rd,wr}msr*_safe* variants
> > which should've been used in the first place anyway and avoided unneeded
> > excitation with xen.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> > Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
> > Cc: stable@vger.kernel.org # 3.4+
> > Link: <http://lkml.kernel.org/r/1338383402-3838-1-git-send-email-andre.przywara@amd.com>
> > [Boris: correct and expand commit message]
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Why -stable?  I though we had agreed that we didn't have an active
> problem (unclean hack, yes, but not an active problem) in 3.4/3.5 as it
> currently sits?

Yes, AFAICT, we need at least one fix for 3.4 where the original patch
f7f286a910221 broke xen.

So either this one or 1ab46fd319bc should be backported to stable, if
I'm not mistaken. If the second, I'll drop the stable tag from this one
and resend.

Konrad, what do you want wrt xen paravirt nullptr breakage for
3.4-stable?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

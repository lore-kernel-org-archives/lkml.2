Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2E3PMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:12:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41122 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab2E3PMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:12:38 -0400
Date: Wed, 30 May 2012 17:12:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
        Andre Przywara <andre.przywara@amd.com>,
        Jacob Shin <Jacob.Shin@amd.com>, mingo@elte.hu, jeremy@goop.org,
        tglx@linutronix.de, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530151235.GB15635@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
	Andre Przywara <andre.przywara@amd.com>,
	Jacob Shin <Jacob.Shin@amd.com>, mingo@elte.hu, jeremy@goop.org,
	tglx@linutronix.de, xen-devel@lists.xensource.com,
	linux-kernel@vger.kernel.org
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <4FC649790200007800086E51@nat28.tlf.novell.com>
 <4FC631F0.9080109@zytor.com>
 <20120530144929.GH3207@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120530144929.GH3207@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:49:29AM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, May 30, 2012 at 07:42:56AM -0700, H. Peter Anvin wrote:
> > On 05/30/2012 07:23 AM, Jan Beulich wrote:
> > > 
> > > I see - the Xen code blindly overwrites pv_cpu_ops, despite not
> > > having initialized all members. That's an obvious oversight of the
> > > patch that introduced the _regs variants.
> > > 
> > > Plus having secondary instances of things like rdmsrl_amd_safe()
> > > in asm/paravirt.h seems pretty strange an approach (which was
> > > why initially I didn't spot how a crash could happen there) - only
> > > the lowest level functions should get re-implemented here.
> > > 
> > 
> > This kinds of things are part of why Xen makes me want to cry regularly.
> 
> It looks like an oversight by Borislav (177fed1ee8d727c39601ce9fc2299b4cb25a718e
> and 132ec92f) and Yinghai (b05f78f5c713eda2c34e495d92495ee4f1c3b5e1) where
> they added these wrappers way back in 2009!

This is exactly why xen has nothing to do in arch/x86/. It is not an
oversight - I simply didn't test it on xen because I don't care about
it.

Remember our last discussion about mcelog?

This current case should be a perfect example for why xen shouldn't be
sprinkling code all over the place.

-- 
Regards/Gruss,
Boris.

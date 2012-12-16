Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2LPUjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:39:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37931 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2LPUjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:39:17 -0500
Date: Sun, 16 Dec 2012 21:39:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Weidong Han <weidong.han@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [regression] 3.7 ends in APIC panic
Message-ID: <20121216203913.GB14643@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org, Weidong Han <weidong.han@intel.com>,
	David Woodhouse <David.Woodhouse@intel.com>
References: <50CB3EAB.309@itwm.fraunhofer.de>
 <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com>
 <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com>
 <50CE0C82.20708@itwm.fraunhofer.de>
 <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
 <50CE12EB.1050804@itwm.fraunhofer.de>
 <20121216191347.GB14678@liondog.tnic>
 <50CE24FE.3030409@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50CE24FE.3030409@itwm.fraunhofer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 08:46:06PM +0100, Bernd Schubert wrote:
> Hmm, I read it the other way around - x2apic depends on interrupt
> remapping, but interrupt remapping can be used without x2apic.

Ok, you're right. X2APIC should depend on IRQ_REMAP:
https://lwn.net/Articles/289881/

> The help text of CONFIG_IRQ_REMAP also says "x2APIC enhancements or to
> support platforms with CPU's having > 8 bit APIC ID, say Y." I guess
> may CPU has the latter?

I think it is what Yinghai said - you obviously need x2apic kernel
support if you have IRQ_REMAP on.

> Can the kernel panic a bit improved to help user to understand what
> needs to be enabled?

Well, your kernel enables IRQ_REMAP properly:

[    0.031115] Enabled IRQ remapping in x2apic mode

I guess at that stage we could probably check for x2apic support and
scream loudly if it is not present... IMHO.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

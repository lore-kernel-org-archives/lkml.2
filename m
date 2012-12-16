Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2LPTNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 14:13:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57146 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab2LPTNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 14:13:51 -0500
Date: Sun, 16 Dec 2012 20:13:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Weidong Han <weidong.han@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [regression] 3.7 ends in APIC panic
Message-ID: <20121216191347.GB14678@liondog.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50CE12EB.1050804@itwm.fraunhofer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 07:28:59PM +0100, Bernd Schubert wrote:
> CONFIG_X86_X2APIC depends on CONFIG_IRQ_REMAP, which I disabled as it
> is marked as experimental...

You shouldn't pay too much attention to CONFIG_EXPERIMENTAL because it
is on its way out from the kernel tree.

But if you don't want to have interrupt remapping on your system,
you can disable it nevertheless. Wait, you can't: according to
d0b03bd1c6725a3463290d7f9626e4b583518a5a, you can use x2apic without
interrupt remapping but interrupt remapping needs to be enabled before
x2apic.

Then there was a build breakage which got fixed in
f7d7f866baacc283967ce82ebdfe5d2801059a11 by turning the select IRQ_REMAP
into depends on.

But, this looks to me like the dependency is reversed here: IRQ_REMAP
should depend on X86_X2APIC and not the other way around, right?

Adding some more people to CC.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

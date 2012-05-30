Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2E3SR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:17:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36140 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab2E3SRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:17:25 -0400
Date: Wed, 30 May 2012 20:17:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530181722.GF15438@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Jacob Shin <jacob.shin@amd.com>,
	Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
	Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
References: <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <20120530144851.GA12184@jshin-Toonie>
 <20120530145005.GI3207@phenom.dumpdata.com>
 <20120530150334.GA13349@jshin-Toonie>
 <20120530171754.GA5115@phenom.dumpdata.com>
 <20120530173247.GC15635@x1.osrc.amd.com>
 <4FC65D34.1060803@zytor.com>
 <20120530175150.GE15438@x1.osrc.amd.com>
 <4FC66037.6020506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC66037.6020506@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:00:23AM -0700, H. Peter Anvin wrote:
> OK.  But there is still the general problem, no?

With this patch xen crashes go away because they paravirt
native_{read,write}_msr_safe.

The other place where we use the amd_safe variants is an obscure K8,
revC and earlier fix for _some_ BIOSen and this hasn't bitten us yet
so I'm assuming people haven't run xen on such boxes yet. Does it need
fixing? Probably, if we really really have to.

Now, someone probably needs to paravirt the *safe_regs variants in case
something else decides to use them. I don't know what to do here, do I
want more paravirt code in there? No. I guess if this is done carefully
and cleanly, then it should be ok but it can't be done like that - it
needs to adhere to the current pv_cpu_ops thing which is already there.

Hmm...

-- 
Regards/Gruss,
Boris.

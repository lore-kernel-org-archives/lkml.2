Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966260Ab0GQKVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 06:21:38 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:16947
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759795Ab0GQKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 06:21:36 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5P63J-02-3HL-02
X-M-MSG: 
Date: Sat, 17 Jul 2010 12:21:08 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100717102108.GA2239@aftab>
References: <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
 <4C3FDF43.6030203@zytor.com>
 <20100716063952.GB27546@aftab>
 <4C3F8418.5020803@zytor.com>
 <20100716072244.GA27954@aftab>
 <4C408298.8060004@zytor.com>
 <20100716162517.GF28902@aftab>
 <4C40DD11.4020803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C40DD11.4020803@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, Jul 16, 2010 at 06:28:33PM -0400

> On 07/16/2010 09:25 AM, Borislav Petkov wrote:
> > 
> > I don't see the need for two things denoting C1E for the very simple
> > reason: when C1E gets enabled on a machine, one of the bits gets set in
> > the MSR on each core simultaneously. So if one core sees one of the bits
> > set, all the remaining cores are seeing them too. The first core that
> > sees one of the bits in the MSR, sets c1e_detected.
> > 
> > So next time any core does cpu_idle() => c1e_idle(), it switches to
> > timer broadcast on it since it might go into C1E if all the others
> > follow.
> > 
> > Frankly, I can't think of a case where we'd need to two things - I
> > could be missing something. But this workaround is a couple of years
> > old, maybe Thomas might give us more insight into whether there's a
> > particular reason for the cpuid flag and the c1e_detected variable.
> > Thomas?
> > 
> 
> I'm not saying there should be two things (and that's clearly wrong no
> matter what), but rather it's not clear to me that the one thing should
> be a variable.

Why not? Once one of the MSR bits is turned on, it stays on until next
reboot. The variable caches that value which will not change and saves
us the rdmsr everytime a cpu goes idle. So I don't see the need to have
a function instead which checks the MSR everytime, for example.

Btw, I think we should wait with whatever fix we come up until the
merge window so that we have more time to fix any fallout then (which I
don't expect but who knows) instead of rushing this now. We can always
backport it then too.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2EWQTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:19:13 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:27302
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab2EWQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:19:10 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dI9371I936eK1432N98dKzz1202hzzz2dh668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M4HHBR-01-FPG-02
X-M-MSG: 
Date: Wed, 23 May 2012 18:19:32 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>, <frank.arnold@amd.com>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        <tglx@linutronix.de>, <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
Message-ID: <20120523161932.GN14757@aftab.osrc.amd.com>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
 <1337789429.9783.16.camel@laptop>
 <4FBD0C47.70600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FBD0C47.70600@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:11:51AM -0700, H. Peter Anvin wrote:
> On 05/23/2012 09:10 AM, Peter Zijlstra wrote:
> > On Wed, 2012-05-23 at 09:07 -0700, tip-bot for Borislav Petkov wrote:
> >> +#define BIT_64(n)                      (U64_C(1) << (n))
> > 
> > Because writing 1ULL << n is too much work? 
> > 
> 
> Because writing 1ULL << n is broken in anything that needs to be used in
> assembly, for example.

Actually we need a BIT() macro that works both
on 32- and 64-bit. But that won't be that easy:
http://lkml.indiana.edu/hypermail/linux/kernel/1010.1/02335.html

And it should return UL for shift values < 32 and ULL otherwise.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551


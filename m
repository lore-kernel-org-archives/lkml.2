Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab1LNXO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:14:27 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:48792
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581Ab1LNXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:14:26 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2dI9371I936eK103dK1432N98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW7V7U-01-215-02
X-M-MSG: 
Date: Wed, 14 Dec 2011 17:14:25 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai.lu@oracle.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
Message-ID: <20111214231425.GA18068@jshin-Toonie>
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
 <4EA09EA2.3030203@zytor.com>
 <1319149574.13035.6.camel@jshin-Toonie>
 <4EE9266A.90200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EE9266A.90200@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 02:42:50PM -0800, H. Peter Anvin wrote:
> On 10/20/2011 03:26 PM, Jacob Shin wrote:
> > On Thu, 2011-10-20 at 17:20 -0500, H. Peter Anvin wrote:
> >> On 10/20/2011 02:15 PM, Jacob Shin wrote:
> >>> On systems with very large memory (1 TB in our case), BIOS may report a
> >>> reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
> >>> these from the direct mapping.
> >>
> >>> +			if (ei->type == E820_RESERVED)
> >>> +				continue;
> >>
> >> This should probably be ei->type != E820_RAM or something similar.  I
> >> haven't looked yet, what does the < 4 GiB code do?
> > 
> > Hm, okay, it calls e820_end_of_low_ram_pfn() which effectively is !=
> > E820_RAM.
> > 
> > I'll fix this, test, then resend.
> > 
> 
> I never got any kind of updated patch, did I?

No, I never sent one out, because it would have still only covered > 4GB, and
in later emails, you said that you wanted a general one that covered all x86.

I'll give it another shot at the generic patch, making a special case for the
< 1MB ISA region.

Thanks!

> 
> 	-hpa
> 
> 


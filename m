Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1JTW0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 18:26:48 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25953
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751462Ab1JTW0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 18:26:46 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zzbb2dK9371K936eK103dK1432N98dKzz1202hzzz32i668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LTDYBK-01-5D2-02
X-M-MSG: 
Message-ID: <1319149574.13035.6.camel@jshin-Toonie>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai.lu@oracle.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Oct 2011 17:26:14 -0500
In-Reply-To: <4EA09EA2.3030203@zytor.com>
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
	 <4EA09EA2.3030203@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 17:20 -0500, H. Peter Anvin wrote:
> On 10/20/2011 02:15 PM, Jacob Shin wrote:
> > On systems with very large memory (1 TB in our case), BIOS may report a
> > reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
> > these from the direct mapping.
> 
> > +			if (ei->type == E820_RESERVED)
> > +				continue;
> 
> This should probably be ei->type != E820_RAM or something similar.  I
> haven't looked yet, what does the < 4 GiB code do?

Hm, okay, it calls e820_end_of_low_ram_pfn() which effectively is !=
E820_RAM.

I'll fix this, test, then resend.

Thanks!

-Jacob Shin
Advanced Micro Devices, Inc.

> 
> 	-hpa
> 
> 




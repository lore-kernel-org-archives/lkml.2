Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1DROwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:52:47 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:21872
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1DROwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:52:42 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zzbb2dK9371O1432N98dKzz1202hzz15d4Rz32i637h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJURZM-02-ASN-02
X-M-MSG: 
Date: Mon, 18 Apr 2011 16:52:30 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 4/4] x86, gart: Make sure GART does not map physmem
 above 1TB
Message-ID: <20110418145230.GH2192@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
 <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
 <4DAC4EC0.80008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DAC4EC0.80008@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:46:24AM -0400, H. Peter Anvin wrote:
> On 04/18/2011 06:45 AM, Joerg Roedel wrote:
> > The GART can only map physical memory below 1TB. Make sure
> > the gart driver in the kernel does not try to map memory
> > above 1TB.
> 
> Where does this limit come from?

>From the hardware. A GART PTE is only 32 bits in size so that it cannot
be expanded. The physical address bits 32-39 are mapped 11:4 in the PTE.
This can not be architecturally expanded to more than 40 physical bits.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


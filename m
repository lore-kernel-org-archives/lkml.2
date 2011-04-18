Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1DRO5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:57:15 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:15255
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995Ab1DRO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:57:06 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zzbb2dK9371O1432N98dKzz1202hzz15d4R8275bh8275dhz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJUS6W-02-B7I-02
X-M-MSG: 
Date: Mon, 18 Apr 2011 16:56:53 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] x86, gart: Don't enforce GART aperture lower-bound
 by alignment
Message-ID: <20110418145653.GI2192@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
 <1303134346-5805-2-git-send-email-joerg.roedel@amd.com>
 <4DAC4E7F.1010502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DAC4E7F.1010502@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:45:19AM -0400, H. Peter Anvin wrote:
> On 04/18/2011 06:45 AM, Joerg Roedel wrote:
> > This patch changes the allocation of the GART aperture to
> > enforce only natural alignment instead of aligning it on
> > 512MB. This big alignment was used to force the GART
> > aperture to be over 512MB. This is enforced by using 512MB
> > as the lower-bound address in the allocation range.
> > 
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> Better implementation of the existing bounds, yes, but I think the
> algorithm is still wrong.  Specifically, 512 MiB seems to have been the
> maximum address of the kernel at some point, but that is historic at
> this point, at least on 64 bits.

I am fine with a smaller lower-bound, but I am not sure what a better
choice is. The comment about kexec seems to be valid. It shouldn't matter
for kdump because in this case the memory is allocated independently and
the kdump kernel will only use this part, but for other kexec uses it is
a bit harder. Probably any number we choose as a lower bound is an
arbitrary choice at some point. But I am open for
suggestions/corrections to this.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


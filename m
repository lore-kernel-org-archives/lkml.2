Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1DRRhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:37:03 -0400
Received: from 8bytes.org ([88.198.83.132]:51607 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab1DRRg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:36:57 -0400
Date: Mon, 18 Apr 2011 19:36:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] x86, gart: Don't enforce GART aperture lower-bound
	by alignment
Message-ID: <20110418173655.GA8155@8bytes.org>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-2-git-send-email-joerg.roedel@amd.com> <4DAC4E7F.1010502@zytor.com> <20110418145653.GI2192@amd.com> <4DAC5E16.1020408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAC5E16.1020408@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 08:51:50AM -0700, H. Peter Anvin wrote:
> On 04/18/2011 07:56 AM, Roedel, Joerg wrote:
> > On Mon, Apr 18, 2011 at 10:45:19AM -0400, H. Peter Anvin wrote:
> >> On 04/18/2011 06:45 AM, Joerg Roedel wrote:
> >>> This patch changes the allocation of the GART aperture to
> >>> enforce only natural alignment instead of aligning it on
> >>> 512MB. This big alignment was used to force the GART
> >>> aperture to be over 512MB. This is enforced by using 512MB
> >>> as the lower-bound address in the allocation range.
> >>>
> >>> Cc: Yinghai Lu <yinghai@kernel.org>
> >>> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >>
> >> Better implementation of the existing bounds, yes, but I think the
> >> algorithm is still wrong.  Specifically, 512 MiB seems to have been the
> >> maximum address of the kernel at some point, but that is historic at
> >> this point, at least on 64 bits.
> > 
> > I am fine with a smaller lower-bound, but I am not sure what a better
> > choice is. The comment about kexec seems to be valid. It shouldn't matter
> > for kdump because in this case the memory is allocated independently and
> > the kdump kernel will only use this part, but for other kexec uses it is
> > a bit harder. Probably any number we choose as a lower bound is an
> > arbitrary choice at some point. But I am open for
> > suggestions/corrections to this.
> > 
> 
> The right thing to do for in-place kexec it to turn it off, not rely on
> any specific magic addresses.  We have had this problem with a number of
> drivers in the context of kexec.

Ok, so changing the start-address to zero seems the best thing to do.
This way the GART will working again on machines with less than 512MB of
RAM (and a BIOS that does not initialize the GART as we want it).

Regards,

	Joerg


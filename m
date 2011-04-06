Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1DFP1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:27:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:32284 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756487Ab1DFP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:27:37 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1432N98dK1447Rzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ8LJ5-01-3OH-02
X-M-MSG: 
Date: Wed, 6 Apr 2011 17:25:52 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110406152552.GU23633@amd.com>
References: <1302088878-25740-1-git-send-email-joerg.roedel@amd.com>
 <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:16:07AM -0400, Alan Stern wrote:
> On Wed, 6 Apr 2011, Joerg Roedel wrote:
> >  	amd_chipset.probe_count++;
> >  	/* probe only once */
> >  	if (amd_chipset.probe_count > 1) {
> >  		spin_unlock_irqrestore(&amd_lock, flags);
> >  		return amd_chipset.probe_result;
> >  	}
> 
> The counter really should be a bool: Has the chipset already been
> probed or not?  After all, nobody cares how many times this routine was 
> called.

The quirk function needs a re-structuring anyway. The code-path is not
very straight-forward and readable. But for this fix I tried to keep the
changes small.

> 
> > +	spin_unlock_irqrestore(&amd_lock, flags);
> 
> This code now contains a bug: You incremented the probe_count _before_
> doing the probe.  If another thread calls this routine right now, it
> will get an incorrect result.
> 
> Fixing this up should be fairly easy.

Okay, I will do. Thanks for the feedback.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


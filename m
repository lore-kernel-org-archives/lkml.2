Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1IMKC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:02:26 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:50448
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab1IMKCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:02:24 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRGH67-01-030-02
X-M-MSG: 
Date: Tue, 13 Sep 2011 12:00:34 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] iommu/core: add fault reporting mechanism
Message-ID: <20110913100034.GJ11701@amd.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com>
 <20110912160252.GE11701@amd.com>
 <CAK=WgbZCDsBk+dueKfAX3ewsvqEnVDN+jW_ftW+BDKnayunOwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbZCDsBk+dueKfAX3ewsvqEnVDN+jW_ftW+BDKnayunOwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 12:21:13PM -0400, Ohad Ben-Cohen wrote:
> On Mon, Sep 12, 2011 at 7:02 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > I still don't get the need for this. It would make sense to encode
> > different types of faults, like page-faults or interrupt-faults.
> 
> Right.
> 
> > When I read the comment above it sounds more like you want to encode
> > different error-levels, like recoverable and unrecoverable error.
> > The exact meaning of these values need to be clarified.
> 
> Well, we currently only need to say "something bad has happened".
> 
> We don't need at this point to tell whether it's a hardware bug,
> inconsistent data, missing page-table entries or whatnot, because we
> don't expect the user (or the iommu core itself) to do anything about
> it. Not that it's not possible though: a valid response one day would
> be to fix the page-table or add a missing TLB (depending on the mode
> the hardware is configured to) but this is not (yet?) implemented. So
> a "general unrecoverable error" is enough at this point, but it's
> certainly makes sense to allow drivers to provide additional types of
> errors/faults - once they are implemented.

But besides real faults all this can be handled in the iommu-driver
itself, right? So there is no need to communicate other errors than
page-faults up to the driver.

For now I think it is the best to remove this IOMMU_ERROR thing. It is
inherent to the function call already. When a real use-case comes up we
can easily add it later.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


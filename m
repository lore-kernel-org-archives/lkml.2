Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab2BIVgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:36:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:55540 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216Ab2BIVgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:36:21 -0500
Message-ID: <1328823358.2903.77.camel@pasglop>
Subject: Re: [PATCH 09/24] PCI, powerpc: Register busn_res for root buses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Date: Fri, 10 Feb 2012 08:35:58 +1100
In-Reply-To: <CAErSpo7ekGn-+Mnyz7KL=fVFH3Ed19AeE3MKkZWJ4bd0Jo7kCw@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	 <1328425088-6562-10-git-send-email-yinghai@kernel.org>
	 <CAErSpo6BwznWf3rq4J2Ao+rrgR4yWqQ0mQGygkd2KmBuA1OD8g@mail.gmail.com>
	 <1328738567.2903.45.camel@pasglop>
	 <CAErSpo7ekGn-+Mnyz7KL=fVFH3Ed19AeE3MKkZWJ4bd0Jo7kCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 11:24 -0800, Bjorn Helgaas wrote:
> My point is that the interface between the arch and the PCI core
> should be simply the arch telling the core "this is the range of bus
> numbers you can use."  If the firmware doesn't give you the HW limits,
> that's the arch's problem.  If you want to assume 0..255 are
> available, again, that's the arch's decision.
> 
> But the answer to the question "what bus numbers are available to me"
> depends only on the host bridge HW configuration.  It does not depend
> on what pci_scan_child_bus() found.  Therefore, I think we can come up
> with a design where pci_bus_update_busn_res_end() is unnecessary.

In an ideal world yes. In a world where there are reverse engineered
platforms on which we aren't 100% sure how thing actually work under the
hood and have the code just adapt on "what's there" (and try to fix it
up -sometimes-), thinks can get a bit murky :-)

But yes, I see your point. As for what is the "correct" setting that
needs to be done so that the patch doesn't end up a regression for us,
I'll have to dig into some ancient HW to dbl check a few things. I hope
0...255 will just work but I can't guarantee it.

What I'll probably do is constraint the core to the values in
hose->min/max, and update selected platforms to put 0..255 in there when
I know for sure they can cope.

Cheers,
Ben.



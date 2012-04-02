Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2DBVXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:23:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:59199 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2DBVXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:23:18 -0400
Message-ID: <1333401767.30734.58.camel@pasglop>
Subject: Re: [PATCH 08/18] PCI, powerpc: Register busn_res for root buses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Milton Miller <miltonm@bga.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Date: Tue, 03 Apr 2012 07:22:47 +1000
In-Reply-To: <powerpc-pci-domains-by-busnumber-resend@mdm.bga.com>
References: <1330472496.11728.31.camel@pasglop>
	 <1330395009-29260-1-git-send-email-yinghai@kernel.org>
	 <1330395009-29260-9-git-send-email-yinghai@kernel.org>
	 <CAErSpo4bw-V=SM+h5iP4nfv3HaAnHjwvNwu+4Oz8iyQcY_3gOQ@mail.gmail.com>
	 <CAErSpo72_JnUkWXrzbNdbX9wiWZtQdX2tuNjEpYrSd+sGzxfzA@mail.gmail.com>
	 <powerpc-pci-domains-by-busnumber-resend@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 05:19 -0500, Milton Miller wrote:
> 
> In the POWER3 era we had several boxes that split the pci bus number
> space across domains and RTAS used the bus number to find the correct
> PHB.   This contineed to the first RS64 boxes.  By S80 and RS64-III
> it was obvious that we didn't have enough numbers to continue this
> ilusion and we added the presently used RTAS calls that take the pci
> domain as well as bus, device, and function numbers.
> 
> The bus numbers split across pci domains started with the F50
> F50 chrp 32 bit platforms. 

Ok, so old CHRPs would have a split as well...

I think the best is to honor the bus-range property of the PHB as min &
max values, and if we feel a need to allow the kernel to assign busses
beyond that, we can always quirk the appropriate platform code.

Cheers,
Ben.



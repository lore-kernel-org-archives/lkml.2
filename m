Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2DBKTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:19:37 -0400
Received: from mail4.comsite.net ([205.238.176.238]:15047 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2DBKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:19:35 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=129.33.192.96;
From: Milton Miller <miltonm@bga.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 08/18] PCI, powerpc: Register busn_res for root buses
Message-Id: <powerpc-pci-domains-by-busnumber-resend@mdm.bga.com>
In-Reply-To: <1330472496.11728.31.camel@pasglop>
References: <1330472496.11728.31.camel@pasglop>
 <1330395009-29260-1-git-send-email-yinghai@kernel.org>
 <1330395009-29260-9-git-send-email-yinghai@kernel.org>
 <CAErSpo4bw-V=SM+h5iP4nfv3HaAnHjwvNwu+4Oz8iyQcY_3gOQ@mail.gmail.com>
 <CAErSpo72_JnUkWXrzbNdbX9wiWZtQdX2tuNjEpYrSd+sGzxfzA@mail.gmail.com>
Date: Mon, 02 Apr 2012 05:19:31 -0500
X-Originating-IP: 129.33.192.96
X-HeloNotChecked: Helo response was not checked before commands sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Apollogies if I left anyone off cc.  I am not subscribed and the archives
go to great pains to hide the to and cc lists, and then truncate it for size]
{fix a comma in cc}

On Tue Feb 28 2012 about 18:42:03 EST, Benjamin Herrenschmidt wrote:
> On Tue, 2012-02-28 at 16:31 -0700, Bjorn Helgaas wrote:
> > We may need mechanism to say "don't trust this info from the
> > firmware," but we should be able to figure out a way that doesn't
> > penalize platforms that do everything correctly. The current patch
> > breaks these scenarios even when the platform firmware is 100%
> > correct.
> 
> On the other hand, our firmwares tend not to be and the vast majority of
> our platforms have separate bus number domains (In fact I'm not sure
> whether we have one that actually splits bus numbers or not, maybe some
> ancient Apple gear, I need to double check).
> 

In the POWER3 era we had several boxes that split the pci bus number
space across domains and RTAS used the bus number to find the correct
PHB.   This contineed to the first RS64 boxes.  By S80 and RS64-III
it was obvious that we didn't have enough numbers to continue this
ilusion and we added the presently used RTAS calls that take the pci
domain as well as bus, device, and function numbers.

The bus numbers split across pci domains started with the F50
F50 chrp 32 bit platforms.

> We did use to force renumbering on macs to avoid bus number collisions
> between domains because of ancient X servers that didn't do domains
> properly but I think we dropped that.
> 
> Cheers,
> Ben.

milton

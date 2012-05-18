Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967357Ab2ERA0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:26:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:16794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966141Ab2ERA0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:26:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167861299"
Date: Thu, 17 May 2012 17:26:45 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Dean Nelson <dnelson@redhat.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] e1000: Reset rx ring index on receive overrun
In-Reply-To: <20120518001202.GN683@type.famille.thibault.fr>
Message-ID: <alpine.WNT.2.00.1205171718160.7900@jbrandeb-mobl2.amr.corp.intel.com>
References: <20120517230140.GZ683@type.famille.thibault.fr> <061C8A8601E8EE4CA8D8FD6990CEA891188439E0@ORSMSX102.amr.corp.intel.com> <20120517232821.GJ683@type.famille.thibault.fr> <20120517233124.GK683@type.famille.thibault.fr>
 <alpine.WNT.2.00.1205171702590.7900@jbrandeb-mobl2.amr.corp.intel.com> <20120518001202.GN683@type.famille.thibault.fr>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1459309-17496-1337300807=:7900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1459309-17496-1337300807=:7900
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT



On Thu, 17 May 2012, Samuel Thibault wrote:
> Brandeburg, Jesse, le Thu 17 May 2012 17:04:04 -0700, a écrit :
> > > BTW, it also happens easily when request_irq takes some time to
> > > complete: since we enable E1000_TCTL_EN before that, the card can have
> > > time to fill the ring before irqs are processed.
> > 
> > I think there may well be a bug in the implementation in kvm.  The 
> > hardware doesn't have this bug.
> 
> How does it avoid filling the ring?  What is the purpose of the RXO flag
> if it does avoid them?

RXO is only used to let the driver know "information" that the rx fifo is 
overflowing.  As it turns out the flag isn't very useful and none of our 
drivers currently use it for anything.

If the hardware fills all the available receive *descriptors* then the 
hardware's RDH (head) register will advance all the way to the RDT (tail) 
value. The tail always points one past the rx descriptors available to 
hardware to use.  RDH==RDT means there are no software provided 
descriptors in the ring available to be used by the hardware.  Our drivers 
typically allow for 1-2 descriptors to be unused in the ring to help avoid 
any confusion.

Hope this helps,
 Jesse
--1459309-17496-1337300807=:7900--

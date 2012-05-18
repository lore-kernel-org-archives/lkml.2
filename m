Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab2ERAMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:12:10 -0400
Received: from solo.fdn.fr ([80.67.169.19]:58037 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933557Ab2ERAMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:12:06 -0400
Date: Fri, 18 May 2012 02:12:02 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "Dave, Tushar N" <tushar.n.dave@intel.com>,
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
Message-ID: <20120518001202.GN683@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Dave, Tushar N" <tushar.n.dave@intel.com>,
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
	"e1000-devel@lists.sourceforge.net" <e1000-devel@lists.sourceforge.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20120517230140.GZ683@type.famille.thibault.fr>
 <061C8A8601E8EE4CA8D8FD6990CEA891188439E0@ORSMSX102.amr.corp.intel.com>
 <20120517232821.GJ683@type.famille.thibault.fr>
 <20120517233124.GK683@type.famille.thibault.fr>
 <alpine.WNT.2.00.1205171702590.7900@jbrandeb-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.WNT.2.00.1205171702590.7900@jbrandeb-mobl2.amr.corp.intel.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brandeburg, Jesse, le Thu 17 May 2012 17:04:04 -0700, a écrit :
> On Thu, 17 May 2012, Samuel Thibault wrote:
> 
> > Samuel Thibault, le Fri 18 May 2012 01:28:21 +0200, a écrit :
> > > Dave, Tushar N, le Thu 17 May 2012 23:22:31 +0000, a écrit :
> > > > I am interested in to see if you have actual test case and more 
> > > > importantly test data that shows that kernel and device indexes are 
> > > > not synchronized any more.
> > > 
> > > Well, it's not with an actual physical device, but with the kvm
> > > emulation.
> > 
> > BTW, it also happens easily when request_irq takes some time to
> > complete: since we enable E1000_TCTL_EN before that, the card can have
> > time to fill the ring before irqs are processed.
> 
> I think there may well be a bug in the implementation in kvm.  The 
> hardware doesn't have this bug.

How does it avoid filling the ring?  What is the purpose of the RXO flag
if it does avoid them?

Samuel

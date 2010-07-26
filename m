Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0GZQpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:45:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:35571 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0GZQpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:45:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,262,1278313200"; 
   d="scan'208";a="304458381"
Date: Mon, 26 Jul 2010 09:45:06 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Andrey Panin <pazke@centrinvest.ru>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>
Subject: Re: Problem with e1000e, 802.1Q VLAN's and IPMI
In-Reply-To: <20100726073920.GD30155@centrinvest.ru>
Message-ID: <alpine.WNT.2.00.1007260936160.4488@jbrandeb-desk1.amr.corp.intel.com>
References: <20100726073920.GD30155@centrinvest.ru>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Jul 2010, Andrey Panin wrote:
> I have a problem using IPMI on Super Micro X7SBL motherboard (AOC-IPMI20-E BMC).
> BMC shares ethernet port with onboard e1000e. It works when IPMI traffic is 
> untagged (CrcStripping=0 module option used), but if I try to use 802.1Q vlan
> for IPMI traffic BMC stops responding right after "ifup eth0". 

We've heard of this issue (or similar) before.  I believe for the other 
guys they had to run IPMI traffic untagged, if your main network is 
running untagged.  The problem in this case is that the tags are being 
stripped in hardware even for the SMBUS packets, at which point the BMC 
that is stupid and doesn't understand offloading hardware gets confused 
that the traffic it is receiving doesn't have a vlan tag.

> I tested 2.6.26 (debian stable kernel) and 2.6.35-rc6.
> Looks like there is some problem with 802.1Q tags stripping/inserting.

Thanks for testing the latest kernel.

> There was no such problem with e1000 driver from 2.6.18.

Hm, that is an interesting statement.  The major changes to the driver 
include stripping tags all the time when not in promisc mode, and there 
have been some fixes and attempts to fix the ipmi issues some 
(particularly supermicro) BMCs have.  I'm quite surprised it worked for 
you at all (there have been quite a few issues in this area)

> Unfortunately I can't provide additional info right now, but I can provide
> it slightly later and I'm ready to test patches.

I can send you a patch to disable vlan stripping in hardware which will 
probably get you working, but I don't think it is production worthy.

Jesse

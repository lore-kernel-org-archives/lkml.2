Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0G3HAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:00:19 -0400
Received: from centrinvest.ru ([94.25.115.130]:58484 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0G3HAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:00:17 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Fri, 30 Jul 2010 11:00:11 +0400
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>
Subject: Re: Problem with e1000e, 802.1Q VLAN's and IPMI
Message-ID: <20100730070011.GA29453@centrinvest.ru>
Mail-Followup-To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"e1000-devel@lists.sourceforge.net" <e1000-devel@lists.sourceforge.net>,
	"Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>,
	"Duyck, Alexander H" <alexander.h.duyck@intel.com>,
	"Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
	"Ronciak, John" <john.ronciak@intel.com>
References: <20100726073920.GD30155@centrinvest.ru>
 <alpine.WNT.2.00.1007260936160.4488@jbrandeb-desk1.amr.corp.intel.com>
 <20100727120552.GA31741@centrinvest.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727120552.GA31741@centrinvest.ru>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 208, 07 27, 2010 at 04:05:52 +0400, Andrey Panin wrote:
> On 207, 07 26, 2010 at 09:45:06AM -0700, Brandeburg, Jesse wrote:
> > 
> > On Mon, 26 Jul 2010, Andrey Panin wrote:
> > > I have a problem using IPMI on Super Micro X7SBL motherboard (AOC-IPMI20-E BMC).
> > > BMC shares ethernet port with onboard e1000e. It works when IPMI traffic is 
> > > untagged (CrcStripping=0 module option used), but if I try to use 802.1Q vlan
> > > for IPMI traffic BMC stops responding right after "ifup eth0". 
> > 
> > We've heard of this issue (or similar) before.  I believe for the other 
> > guys they had to run IPMI traffic untagged, if your main network is 
> > running untagged.  The problem in this case is that the tags are being 
> > stripped in hardware even for the SMBUS packets, at which point the BMC 
> > that is stupid and doesn't understand offloading hardware gets confused 
> > that the traffic it is receiving doesn't have a vlan tag.
> 
> I suspected something like that. Unfortunately Super Micro isn't interested
> in fixing their BMC, at least latest firmware doesn't fix the issue.
> 
> > > I tested 2.6.26 (debian stable kernel) and 2.6.35-rc6.
> > > Looks like there is some problem with 802.1Q tags stripping/inserting.
> > 
> > Thanks for testing the latest kernel.
> > 
> > > There was no such problem with e1000 driver from 2.6.18.
> > 
> > Hm, that is an interesting statement.  The major changes to the driver 
> > include stripping tags all the time when not in promisc mode, and there 
> > have been some fixes and attempts to fix the ipmi issues some 
> > (particularly supermicro) BMCs have.  I'm quite surprised it worked for 
> > you at all (there have been quite a few issues in this area)
> 
> After some sleep I'm not so sure that it was really working :(
> I'll retest it more thoroughly this evening.

After retest I can confirm that tagged IPMI works with 2.6.18 e1000 driver.

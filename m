Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab0ENXoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:44:00 -0400
Received: from mga05.intel.com ([192.55.52.89]:4883 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751365Ab0ENXn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,234,1272870000"; 
   d="scan'208";a="798619110"
Date: Fri, 14 May 2010 16:43:53 -0700
From: mark gross <mgross@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: mmotm 2010-05-11 - dies in pm_qos_update_request()
Message-ID: <20100514234353.GA14494@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
 <201005122307.20860.rjw@sisk.pl>
 <4793.1273761278@localhost>
 <201005140024.50279.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005140024.50279.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 12:24:50AM +0200, Rafael J. Wysocki wrote:
> On Thursday 13 May 2010, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 12 May 2010 23:07:20 +0200, "Rafael J. Wysocki" said:
> > > On Wednesday 12 May 2010, Valdis.Kletnieks@vt.edu wrote:
> > > > On Tue, 11 May 2010 18:21:22 PDT, akpm@linux-foundation.org said:
> > > > > The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
> > > > > 
> > > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > 
> > > > Dell Latitude E6500, x86_64 kernel.
> > > > 
> > > > Died a horrid death at boot in the e1000e driver.  Seems to be
> > > > something in linux-next.patch. Didn't get a netconsole trace for obvious
> > > > reasons...
> > > > 
> > > > Copied-by-hand traceback:
> > > > pm_qos_update_request()+0x22
> > > > e1000_configure+0x478
> > > > e1000_open_device+0xee
> > > > ? _raw_notifier_call_chain+0xf
> > > > __dev_open+0xec
> > > > dev_open+0x1b
> > > > netpoll_setup+0x28b
> > > > init_netconsole+0xbc
> > > > 
> > > > I suspect this commit:
> > > > 
> > > > commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
> > > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > > Date:   Sun Mar 14 14:35:17 2010 +0000
> > > > 
> > > >     e1000e / PCI / PM: Add basic runtime PM support (rev. 4)
> > > 
> > > No, I don't think so.  I'm running -rc6 with this patch applied on a box with
> > > e1000e and it works just fine.
> > > 
> > > Please try to revert this one instead:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=patch;h=ed77134bfccf5e75b6cbadab268e559dbe6a4ebb
> > 
> > Confirming - reverting that patch and doing the build fixup results in a
> > kernel that doesn't blow up in the e1000e driver...
> 
> Then I guess there's an initializations problem somewhere.
> 
> Mark, any chance to look into that any time soon?  If we don't resolve this
> before the merge window opens, I'm afraid I'll have to revert that commit
> from my tree.
>

I'll look at it right away.

I think I have an e1000e in my home box.

--mgross

 

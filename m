Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1CBXXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:23:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:16326 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab1CBXXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:23:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,255,1297065600"; 
   d="scan'208";a="396622458"
From: "Nadolski, Edmund" <edmund.nadolski@intel.com>
To: Mel Gorman <mel@csn.ul.ie>, Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Date: Wed, 2 Mar 2011 16:22:53 -0700
Subject: RE: inconsistent lock state message on 2.6.36.4 stable release
Thread-Topic: inconsistent lock state message on 2.6.36.4 stable release
Thread-Index: AcvZHWCiU7muotBTTJOElR40JXrrRgAEv+rg
Message-ID: <9EECC02A4CC333418C00A85D21E893261498F459DF@azsmsx502.amr.corp.intel.com>
References: <9EECC02A4CC333418C00A85D21E893261498F45872@azsmsx502.amr.corp.intel.com>
 <20110302202515.GA16963@suse.de> <20110302210338.GF14162@csn.ul.ie>
In-Reply-To: <20110302210338.GF14162@csn.ul.ie>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mel Gorman [mailto:mel@csn.ul.ie]
> Sent: Wednesday, March 02, 2011 2:04 PM
> To: Greg KH
> Cc: Nadolski, Edmund; linux-kernel@vger.kernel.org; Williams, Dan J
> Subject: Re: inconsistent lock state message on 2.6.36.4 stable release
> 
> On Wed, Mar 02, 2011 at 03:25:15PM -0500, Greg KH wrote:
> > On Wed, Mar 02, 2011 at 01:19:48PM -0700, Nadolski, Edmund wrote:
> > > With v2.6.36.4 stable release and CONFIG_PROVE_LOCKING set, I
> notice
> > > the below message during boot (full dmesg attached):
> >
> > 2.6.36 is now "end of life" so there's really no need to test, debug,
> or
> > report problems here as there's nothing we can do about it.
> >
> > > Per git bisect, it seems to have originated with this commit:
> > >
> > > $ git bisect good
> > > c04eb9683fbb6374275309b859fcbf02e1db2c78 is the first bad commit
> > > commit c04eb9683fbb6374275309b859fcbf02e1db2c78
> > > Author: Mel Gorman <mel@csn.ul.ie>
> > > Date:   Thu Jan 13 15:45:41 2011 -0800
> > >
> > >     mm: page allocator: adjust the per-cpu counter threshold when
> memory is low
> > >
> > >     commit 88f5acf88ae6a9778f6d25d0d5d7ec2d57764a97 upstream.
> > >
> > > The message goes away after I do a git revert on this commit. I've
> > > also seen this message on 2.6.37.2, but not on 2.6.38-rc7.
> >
> > Care to figure out what commit fixed this so that we can backport it
> to
> > the .37-stable kernel?
> >
> > git bisect can be used to do this as well.
> >
> 
> It looks like the call to get_online_cpus() that is causing the
> problem. If
> so, I believe it to be fixed by the commit [b44129b3: mm: vmstat: use a
> single setter function and callback for adjusting percpu thresholds].
> Edmund, care to test with that patch applied?

This patch looks good, I've applied it onto 2.6.37.2 and I no longer see the message.

Thanks!
Ed



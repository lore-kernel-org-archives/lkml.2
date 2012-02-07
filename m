Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2BGS0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:26:37 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:27203 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751507Ab2BGS0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:26:36 -0500
Message-ID: <1328639192.3549.14.camel@bwh-desktop>
Subject: RE: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
CC: David Miller <davem@davemloft.net>, "steweg@ynet.sk" <steweg@ynet.sk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Tue, 7 Feb 2012 18:26:32 +0000
In-Reply-To: <C5551D9AAB213A418B7FD5E4A6F30A0702F81413@ORSMSX106.amr.corp.intel.com>
References: <5422254.3711328278789768.JavaMail.root@5-MeO-DMT.ynet.sk>
	 <10521320.3761328279061644.JavaMail.root@5-MeO-DMT.ynet.sk>
	 <20120203.192933.510206531351047222.davem@davemloft.net>
	 <C5551D9AAB213A418B7FD5E4A6F30A0702F7F86F@ORSMSX106.amr.corp.intel.com>
	 <1328572230.12637.18.camel@deadeye>
	 <C5551D9AAB213A418B7FD5E4A6F30A0702F81413@ORSMSX106.amr.corp.intel.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18694.005
X-TM-AS-Result: No--31.899900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 00:13 +0000, Rose, Gregory V wrote:
> > -----Original Message-----
> > From: Ben Hutchings [mailto:bhutchings@solarflare.com]
> > Sent: Monday, February 06, 2012 3:51 PM
> > To: Rose, Gregory V
> > Cc: David Miller; steweg@ynet.sk; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org
> > Subject: RE: [patch v1, kernel version 3.2.1] rtnetlink workaround around
> > the skb buff size issue
> > 
> > On Mon, 2012-02-06 at 04:41 +0000, Rose, Gregory V wrote:
> > [...]
> > > > This is not how we're going to fix this.  I already stated the desired
> > > > way to fix this, which is to make the existing dump request have a way
> > > > for the requestor to enable extended parts of the device dump.
> > > >
> > > > This is just like netlink diag socket dumps, where the dump request
> > > > specifies what the user wants to see.
> > > >
> > > > In this case we'd add a netlink attribute to the dump request which
> > > > is just a u32 bitmask or similar.
> > > >
> > > > The Intel engineer who added the VF dump support said he would work on
> > > > this fix so why don't you just wait patiently for him to do the work?
> > >
> > > The patch below is what I've got so far.  Right now the bit mask array
> > > is global so if you enable display of VF (n) on one interface it will
> > > enable display of the same VF on other interfaces.  I intend to move
> > > the bit mask array into the net_device structure so we can set the
> > > display mask for each interface independently.
> > 
> > I don't think this can work.  Using an application that requests VF
> > information and uses large buffers (e.g. the updated 'ip') will break
> > another application that doesn't (e.g. current Network Manager), won't
> > it?
> 
> It's my understanding that the problem isn't with the application
> buffer size but with the kernel buffer size, which is limited to a
> page.
[...]

Then it's no wonder you're going about this the wrong way.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


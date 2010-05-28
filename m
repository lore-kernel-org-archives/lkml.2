Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0E1XgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 19:36:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48513 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752631Ab0E1XgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 19:36:13 -0400
Date: Fri, 28 May 2010 18:36:23 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Greg KH <gregkh@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH V3] x86, UV: BAU performance and error recovery
Message-ID: <20100528233623.GA11356@sgi.com>
References: <E1OHzgl-0000Pj-6o@eag09.americas.sgi.com> <4BFFEFA1.1020307@zytor.com> <20100528164725.GA29208@suse.de> <20100528194334.GA7707@sgi.com> <20100528222321.GC25513@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528222321.GC25513@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, May 28, 2010 at 03:23:21PM -0700, Greg KH wrote:
> On Fri, May 28, 2010 at 02:43:35PM -0500, Cliff Wickman wrote:
> > 
> > On Fri, May 28, 2010 at 09:47:25AM -0700, Greg KH wrote:
> > > On Fri, May 28, 2010 at 09:30:25AM -0700, H. Peter Anvin wrote:
> > > > On 05/28/2010 06:33 AM, Cliff Wickman wrote:
> > > > > - adds modification of tuning variables through /proc/sgi_uv
> > > > 
> > > > Adding new directories in /proc for a proprietary architecture is
> > > > frowned upon, to put it mildly.  At the very least try to find a place
> > > > in sysfs for it.
> > > > 
> > > > [Cc: gregkh in order to find a place in sysfs]
> > > 
> > > Hm, what type of files are you needing here?  Do they corrispond with
> > > any specific hardware devices?  If so, just put them on the hardware
> > > devices in sysfs.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > There is an SGI-specific directory in sysfs: /sys/firmware/sgi_uv
> > though the tuning variables for the handling of the hardware Broadcast
> > Assist Unit don't fit there very logically.  
> > 
> > The BAU's statistics are already displayed through the UV-only
> > /proc/sgi_uv/ptc_statistics.  This was deemed necessary because of the
> > potentially very large size of that file --- it is still true that a /sys file
> > is limited to one page, is it not?
> 
> It is limited to one single value, which would never be larger than a
> page, so yes, it is limited to one page.
> 
> What kind of information are you showing here?  Should this thing just
> be in debugfs instead?  You can do whatever you want there.
> 
> thanks,
> 
> greg k-h

/proc/sgi_uv/bau_tunables would be a read/write file to display and change
nine threshold and delay values for tuning the BAU driver.

I like debugfs, except that a distro may not build the kernel with it
configured on.  The tunables should be available as administrative
options on a customer kernel, not just as a development tool.

And in our case the distros are already building with other such writable
options in /proc/sgi_uv.  We'd like to postpone a wholesale move of such
options (assuming there will be some better place) and stay with the existing
location for this release.

I know we (the community) would like to move non-process info out of /proc.
It seems to me that we need a similar filesystem for large and/or 
administrative files.  That's my perspective.

-Cliff
-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824

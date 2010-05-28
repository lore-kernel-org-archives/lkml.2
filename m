Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0E1Tn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:43:29 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57501 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753937Ab0E1Tn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:43:26 -0400
Date: Fri, 28 May 2010 14:43:35 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Greg KH <gregkh@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH V3] x86, UV: BAU performance and error recovery
Message-ID: <20100528194334.GA7707@sgi.com>
References: <E1OHzgl-0000Pj-6o@eag09.americas.sgi.com> <4BFFEFA1.1020307@zytor.com> <20100528164725.GA29208@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528164725.GA29208@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, May 28, 2010 at 09:47:25AM -0700, Greg KH wrote:
> On Fri, May 28, 2010 at 09:30:25AM -0700, H. Peter Anvin wrote:
> > On 05/28/2010 06:33 AM, Cliff Wickman wrote:
> > > - adds modification of tuning variables through /proc/sgi_uv
> > 
> > Adding new directories in /proc for a proprietary architecture is
> > frowned upon, to put it mildly.  At the very least try to find a place
> > in sysfs for it.
> > 
> > [Cc: gregkh in order to find a place in sysfs]
> 
> Hm, what type of files are you needing here?  Do they corrispond with
> any specific hardware devices?  If so, just put them on the hardware
> devices in sysfs.
> 
> thanks,
> 
> greg k-h

There is an SGI-specific directory in sysfs: /sys/firmware/sgi_uv
though the tuning variables for the handling of the hardware Broadcast
Assist Unit don't fit there very logically.  

The BAU's statistics are already displayed through the UV-only
/proc/sgi_uv/ptc_statistics.  This was deemed necessary because of the
potentially very large size of that file --- it is still true that a /sys file
is limited to one page, is it not?  We wanted to minimize the overhead
of the monitoring tools that read those statistics.
And the BAU tuning is related to those statistics.  That's why I chose
to put them along side, in /proc/sgi_uv/bau_tunables.
Even though it is a very small file.

Does that logic hold any water?

-Cliff
-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824

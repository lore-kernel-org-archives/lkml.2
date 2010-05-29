Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0E2AKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 20:10:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:54880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab0E2AKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 20:10:31 -0400
Date: Fri, 28 May 2010 17:05:26 -0700
From: Greg KH <gregkh@suse.de>
To: Cliff Wickman <cpw@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH V3] x86, UV: BAU performance and error recovery
Message-ID: <20100529000526.GA30938@suse.de>
References: <E1OHzgl-0000Pj-6o@eag09.americas.sgi.com>
 <4BFFEFA1.1020307@zytor.com>
 <20100528164725.GA29208@suse.de>
 <20100528194334.GA7707@sgi.com>
 <20100528222321.GC25513@suse.de>
 <20100528233623.GA11356@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528233623.GA11356@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 06:36:23PM -0500, Cliff Wickman wrote:
> /proc/sgi_uv/bau_tunables would be a read/write file to display and change
> nine threshold and delay values for tuning the BAU driver.
> 
> I like debugfs, except that a distro may not build the kernel with it
> configured on.  The tunables should be available as administrative
> options on a customer kernel, not just as a development tool.

All distros have debugfs turned on now, and mounted, due to the perf
interface there, as well as a lot of other good debug information that
is present.

So you don't have to worry about that.

> And in our case the distros are already building with other such writable
> options in /proc/sgi_uv.  We'd like to postpone a wholesale move of such
> options (assuming there will be some better place) and stay with the existing
> location for this release.

So because some distro took a non-upstream patch, you want upstream to
accept the patch despite it being the incorrect place to put such a
file?  Heh, you might want to rethink that...

> I know we (the community) would like to move non-process info out of /proc.

Yes.  We also don't want new files added there that are not dealing with
processes.

> It seems to me that we need a similar filesystem for large and/or 
> administrative files.  That's my perspective.

I do not know of any other such "large administrative" file that needs
to be added to the system at such a time, becides this one, do you?

So please, just put it in debugfs.

thanks,

greg k-h

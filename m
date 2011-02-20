Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1BTUWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 15:22:52 -0500
Received: from kroah.org ([198.145.64.141]:41572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab1BTUWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:22:50 -0500
Date: Sun, 20 Feb 2011 12:07:55 -0800
From: Greg KH <greg@kroah.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110220200755.GA26243@kroah.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
 <4D5DC368.2080003@bluewatersys.com>
 <20110218005852.GA14546@kroah.com>
 <201102210625.08616.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102210625.08616.manningc2@actrix.gen.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 06:25:08AM +1300, Charles Manning wrote:
> On Friday 18 February 2011 13:58:52 Greg KH wrote:
> > On Fri, Feb 18, 2011 at 01:55:04PM +1300, Ryan Mallon wrote:
> > > On 02/18/2011 01:43 PM, Mark Brown wrote:
> > > > On Thu, Feb 17, 2011 at 04:33:53PM -0800, Greg KH wrote:
> > > >> On Fri, Feb 18, 2011 at 12:01:50AM +0000, Mark Brown wrote:
> > > >>> For the proc stuff - for tracing stuff then tracepoints are likely to
> > > >>> be a good option if it's useful to people.
> > > >>
> > > >> Then use the in-kernel tracing functionality, don't roll your own. 
> > > >> And that is not in /proc, so it should be there for this filesystem
> > > >> either.
> > > >
> > > > That'd be the tracepoints I was mentioning, then...
> > >
> > > Are you suggesting that the yaffs_trace function should be replaced with
> > > tracepoints?
> > >
> > > yaffs_trace is basically just a wrapper around printk, which I suggested
> > > should be replaced with pr_debug so that it can be compiled out
> > > completely. Other drivers and filesystems have similar custom debugging
> > > functions.
> > >
> > > I haven't used tracepoints, but it seems like they are better suited to
> > > tracing specific events than as a general printk style debugging
> > > replacement?
> 
> The procfs is not used for tracing as , it is just one of the two ways 
> ofsetting a trace mask to  select what to trace (the other is to set a trace 
> mask).
> 
> eg.  echo +gc > /proc/yaffs
> 
> turns on the garbage collector tracing.
> 
> I will remove the /proc interface and write a userspace script to do the 
> equivalent.
> 
> Realtime selection of tracing is valuable. It allows you to set up a test case 
> with tracing disabled then select what you want to trace to get detail as you 
> run the test case

I agree, so please use the in-kernel tracing code which provides this
infrastructure for you.

> I still intend to keep the tracing printk-based tracing:
> 
> #define yaffs_trace(msk, fmt, ...) do { \
> 	if (yaffs_trace_mask & (msk)) \
> 		printk(KERN_DEBUG "yaffs: " fmt "\n", ##__VA_ARGS__); \
> } while (0)

No, please don't invent your own stuff like this, again, use the
in-kernel functionality provided for this.

thanks,

greg k-h

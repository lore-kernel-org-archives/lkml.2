Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab1BRA7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:59:07 -0500
Received: from kroah.org ([198.145.64.141]:37059 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab1BRA65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:58:57 -0500
Date: Thu, 17 Feb 2011 16:58:52 -0800
From: Greg KH <greg@kroah.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Charles Manning <manningc2@actrix.gen.nz>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110218005852.GA14546@kroah.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
 <201102171531.03924.manningc2@actrix.gen.nz>
 <4D5C8D62.4060809@bluewatersys.com>
 <201102171649.57457.manningc2@actrix.gen.nz>
 <20110217234154.GA1474@kroah.com>
 <20110218000150.GA27668@opensource.wolfsonmicro.com>
 <20110218003353.GA25386@kroah.com>
 <20110218004354.GB27668@opensource.wolfsonmicro.com>
 <4D5DC368.2080003@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5DC368.2080003@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 01:55:04PM +1300, Ryan Mallon wrote:
> On 02/18/2011 01:43 PM, Mark Brown wrote:
> > On Thu, Feb 17, 2011 at 04:33:53PM -0800, Greg KH wrote:
> >> On Fri, Feb 18, 2011 at 12:01:50AM +0000, Mark Brown wrote:
> > 
> >>> For the proc stuff - for tracing stuff then tracepoints are likely to be
> >>> a good option if it's useful to people.
> > 
> >> Then use the in-kernel tracing functionality, don't roll your own.  And
> >> that is not in /proc, so it should be there for this filesystem either.
> > 
> > That'd be the tracepoints I was mentioning, then...
> 
> Are you suggesting that the yaffs_trace function should be replaced with
> tracepoints?
> 
> yaffs_trace is basically just a wrapper around printk, which I suggested
> should be replaced with pr_debug so that it can be compiled out
> completely. Other drivers and filesystems have similar custom debugging
> functions.
> 
> I haven't used tracepoints, but it seems like they are better suited to
> tracing specific events than as a general printk style debugging
> replacement?

If you want printk(), then yes, use pr_debug() as it ties into the
dynamic debug infrastructure, which is great.

Then you can remove the proc files, as the kernel already controls the
debug interface through the standard way, no need for a custom one.

thanks,

greg k-h

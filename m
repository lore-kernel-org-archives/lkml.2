Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab1CBUYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:24:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab1CBUYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:24:51 -0500
Date: Wed, 2 Mar 2011 15:25:15 -0500
From: Greg KH <gregkh@suse.de>
To: "Nadolski, Edmund" <edmund.nadolski@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: inconsistent lock state message on 2.6.36.4 stable release
Message-ID: <20110302202515.GA16963@suse.de>
References: <9EECC02A4CC333418C00A85D21E893261498F45872@azsmsx502.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9EECC02A4CC333418C00A85D21E893261498F45872@azsmsx502.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 01:19:48PM -0700, Nadolski, Edmund wrote:
> With v2.6.36.4 stable release and CONFIG_PROVE_LOCKING set, I notice
> the below message during boot (full dmesg attached):

2.6.36 is now "end of life" so there's really no need to test, debug, or
report problems here as there's nothing we can do about it.

> Per git bisect, it seems to have originated with this commit:
> 
> $ git bisect good
> c04eb9683fbb6374275309b859fcbf02e1db2c78 is the first bad commit
> commit c04eb9683fbb6374275309b859fcbf02e1db2c78
> Author: Mel Gorman <mel@csn.ul.ie>
> Date:   Thu Jan 13 15:45:41 2011 -0800
> 
>     mm: page allocator: adjust the per-cpu counter threshold when memory is low
> 
>     commit 88f5acf88ae6a9778f6d25d0d5d7ec2d57764a97 upstream.
> 
> The message goes away after I do a git revert on this commit. I've
> also seen this message on 2.6.37.2, but not on 2.6.38-rc7.

Care to figure out what commit fixed this so that we can backport it to
the .37-stable kernel?

git bisect can be used to do this as well.

thanks,

greg k-h

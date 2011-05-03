Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab1ECJyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:54:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58197 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab1ECJyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:54:05 -0400
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
From: Colin Ian King <colin.king@canonical.com>
To: Mel Gorman <mgorman@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>, mgorman@novell.com
In-Reply-To: <20110428171826.GZ4658@suse.de>
References: <1303926637.2583.17.camel@mulgrave.site>
	 <1303934716.2583.22.camel@mulgrave.site> <1303990590.2081.9.camel@lenovo>
	 <20110428135228.GC1696@quack.suse.cz> <20110428140725.GX4658@suse.de>
	 <1304000714.2598.0.camel@mulgrave.site> <20110428150827.GY4658@suse.de>
	 <1304006499.2598.5.camel@mulgrave.site>
	 <1304009438.2598.9.camel@mulgrave.site>
	 <1304009778.2598.10.camel@mulgrave.site>  <20110428171826.GZ4658@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 10:54:00 +0100
Message-ID: <1304416440.6005.5.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 18:18 +0100, Mel Gorman wrote:
> On Thu, Apr 28, 2011 at 11:56:17AM -0500, James Bottomley wrote:
> > On Thu, 2011-04-28 at 11:50 -0500, James Bottomley wrote:
> > > This is the output of perf record -g -a -f sleep 5
> > > 
> > > (hopefully the list won't choke)
> > 
> > Um, this one actually shows kswapd
> > 
> > James
> > 
> > ---
> > 
> > # Events: 6K cycles
> > #
> > # Overhead      Command        Shared Object                                   Symbol
> > # ........  ...........  ...................  .......................................
> > #
> >     20.41%      kswapd0  [kernel.kallsyms]    [k] shrink_slab
> >                 |
> >                 --- shrink_slab
> >                    |          
> >                    |--99.91%-- kswapd
> >                    |          kthread
> >                    |          kernel_thread_helper
> >                     --0.09%-- [...]
> > 
> 
> Ok. I can't see how the patch "mm: vmscan: reclaim order-0 and use
> compaction instead of lumpy reclaim" is related unless we are seeing
> two problems that happen to manifest in a similar manner.

That is a distinct possibility.
> 
> However, there were a number of changes made to dcache in particular
> for 2.6.38. Specifically thinks like dentry_kill use trylock and is
> happy to loop around if it fails to acquire anything. See things like
> this for example;
> 
[ text deleted ]

> Way hey, cgroups are also in the mix. How jolly.
> 
> Is systemd a common element of the machines hitting this bug by any
> chance?

Not in my case, using upstart on my machine.
> 
Colin



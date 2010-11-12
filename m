Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab0KLRCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:02:41 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:43160 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560Ab0KLRCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:02:41 -0500
X-Greylist: delayed 2394 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 12:02:40 EST
Subject: Re: [PATCH/RFC] MM slub: add a sysfs entry to show the calculated
 number of fallback slabs
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1011120911310.11746@router.home>
References: <1289561309.1972.30.camel@castor.rsk>
	 <alpine.DEB.2.00.1011120911310.11746@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 16:22:44 +0000
Message-ID: <1289578964.1972.43.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 09:13 -0600, Christoph Lameter wrote:
> On Fri, 12 Nov 2010, Richard Kennedy wrote:
> 
> > On my desktop workloads (kernel compile etc) I'm seeing surprisingly
> > little slab fragmentation. Do you have any suggestions for test cases
> > that will fragment the memory?
> 
> Do a massive scan through huge amounts of files that triggers inode and
> dentry reclaim?

thanks, I'll give it a try.

> > + * Note that this can give the wrong answer if the user has changed the
> > + * order of this slab via sysfs.
> 
> Not good. Maybe have an additional counter in kmem_cache_node instead?


I know it's not ideal. Of course there already is a counter in
CONFIG_SLUB_STATS but it only counts the total number of fallback slabs
issued since boot time.
I'm not sure if I can reliably decrement a fallback counter when a slab
get freed. If the size was changed then we could have slabs with several
different sizes, and off the top of my head I'm not sure if I can
identify which ones were created as fallback slabs. I don't suppose
there's a spare flag anywhere. 

I'll give this some more thought.

regards
Richard   


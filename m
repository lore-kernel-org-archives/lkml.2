Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab0KQXo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:44:28 -0500
Received: from fep17.mx.upcmail.net ([62.179.121.37]:39786 "EHLO
	fep17.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0KQXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:44:27 -0500
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH 06/13] writeback: bdi write bandwidth estimation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Li Shaohua <shaohua.li@intel.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101117153827.e9f169d1.akpm@linux-foundation.org>
References: <20101117042720.033773013@intel.com>
	 <20101117042850.002299964@intel.com>
	 <20101117150837.a18d56c1.akpm@linux-foundation.org>
	 <1290036299.2109.1288.camel@laptop>
	 <20101117153827.e9f169d1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 00:43:32 +0100
Message-ID: <1290037412.24491.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=HQ3F56nxkum+cgCiDL7AXQpbvw7DWrWCBJRnYYnM0Zc= c=1 sm=0 a=KErA6q9OHrUA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=J_RJI74puKMc2kXeYKwA:9 a=FWwI62vKsUR9TZ4hV5Qt65149XsA:4 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:38 -0800, Andrew Morton wrote:
> On Thu, 18 Nov 2010 00:24:59 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2010-11-17 at 15:08 -0800, Andrew Morton wrote:
> > > On Wed, 17 Nov 2010 12:27:26 +0800
> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > +     w = min(elapsed / (HZ/100), 128UL);
> > > 
> > > I did try setting HZ=10 many years ago, and the kernel blew up.
> > > 
> > > I do recall hearing of people who set HZ very low, perhaps because
> > > their huge machines were seeing performance prolems when the timer tick
> > > went off.  Probably there's no need to do that any more.
> > > 
> > > But still, we shouldn't hard-wire the (HZ >= 100) assumption if we
> > > don't absolutely need to, and I don't think it is absolutely needed
> > > here.  
> > 
> > People who do cpu bring-up on very slow FPGAs also lower HZ as far as
> > possible.
> 
> 	grep -r "[^a-zA-Z0-9_]HZ[ ]*/[ ]*100[^0-9]" .

Maybe they've got a patch-kit somewhere,. I'll ask around. It would be
nice to have that sorted.



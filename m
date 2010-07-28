Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0G1WAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:00:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59919 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab0G1WAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:00:51 -0400
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
From: Mingming Cao <cmm@us.ibm.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: bchociej@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <4C4F6DF2.6090905@ontolinux.com>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
	 <4C4F6DF2.6090905@ontolinux.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 15:00:48 -0700
Message-ID: <1280354448.7694.4.camel@mingming-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 01:38 +0200, Christian Stroetmann wrote:
> At the 28.07.2010 00:00, Ben Chociej wrote:
> > INTRODUCTION:
> >
> > This patch series adds experimental support for tracking data
> > temperature in Btrfs. Essentially, this means maintaining some key
> > stats (like number of reads/writes, last read/write time, frequency of
> > reads/writes), then distilling those numbers down to a single
> > "temperature" value that reflects what data is "hot."
> >
> > The long-term goal of these patches, as discussed in the Motivation
> > section at the end of this message, is to enable Btrfs to perform
> > automagic relocation of hot data to fast media like SSD. This goal has
> > been motivated by the Project Ideas page on the Btrfs wiki.
> >
> > Of course, users are warned not to run this code outside of development
> > environments. These patches are EXPERIMENTAL, and as such they might
> > eat your data and/or memory.
> >
> >
> > MOTIVATION:
> >
> > The overall goal of enabling hot data relocation to SSD has been
> > motivated by the Project Ideas page on the Btrfs wiki at
> > https://btrfs.wiki.kernel.org/index.php/Project_ideas. It is hoped that
> > this initial patchset will eventually mature into a usable hybrid
> > storage feature set for Btrfs.
> >
> > This is essentially the traditional cache argument: SSD is fast and
> > expensive; HDD is cheap but slow. ZFS, for example, can already take
> > advantage of SSD caching. Btrfs should also be able to take advantage
> > of hybrid storage without any broad, sweeping changes to existing code.
> >    
> 
> Wouldn't this feature be useful for other file systems as well, so that 
> a more general and not an only Btrfs related solution is preferable?
> 

Would certainly nice to add this feature to all filesystem, but right
now btrfs is the only fs which have multiple device support in itself.

Mingming
> > With Btrfs's COW approach, an external cache (where data is *moved* to
> > SSD, rather than just cached there) makes a lot of sense. Though these
> > patches don't enable any relocation yet, they do lay an essential
> > foundation for enabling that functionality in the near future. We plan
> > to roll out an additional patchset introducing some of the automatic
> > migration functionality in the next few weeks.
> >
> >    
> 
>   With all the best
> Christian Stroetmann
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



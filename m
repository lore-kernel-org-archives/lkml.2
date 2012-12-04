Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab2LDAyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 19:54:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2LDAyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 19:54:38 -0500
Date: Mon, 3 Dec 2012 16:54:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Restore /proc/partitions to not display
 non-partitionable removable devices
Message-Id: <20121203165436.0542933f.akpm@linux-foundation.org>
In-Reply-To: <50BD4680.7090103@akamai.com>
References: <1353380209-23799-1-git-send-email-johunt@akamai.com>
	<20121203160647.11ad34d8.akpm@linux-foundation.org>
	<50BD4680.7090103@akamai.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Dec 2012 18:40:32 -0600
Josh Hunt <johunt@akamai.com> wrote:

> On 12/03/2012 06:06 PM, Andrew Morton wrote:
> > On Mon, 19 Nov 2012 18:56:49 -0800
> > Josh Hunt <johunt@akamai.com> wrote:
> >
> >> We found with newer kernels we started seeing the cdrom device showing
> >> up in /proc/partitions, but it was not there before. Looking into this I found
> >> that commit d27769ec... block: add GENHD_FL_NO_PART_SCAN introduces this change
> >> in behavior. It's not clear to me from the commit's changelog if this change was
> >> intentional or not. This comment still remains:
> >> /* Don't show non-partitionable removeable devices or empty devices */
> >> so I've decided to send a patch to restore the behavior of not printing
> >> unpartitionable removable devices.
> >
> > d27769ec was merged in August 2011, so I after all this time, your fix
> > could be viewed as "changing existing behaviour".
> >
> > So perhaps it would be best to leave things alone.  Is there any
> > particular problem with the post-Aug, 2011 behaviour?
> >
> 
> We caught this by a script that parses /proc/partitions and made some 
> assumptions about the contents therein. It had worked fine up until when 
> this behavior changed. We were able to modify our script to get what we 
> needed.
> 
> The patch was meant to do two things: 1) understand if this was an 
> unintended change and 2) if so, propose a solution to resolve it. Since 
> the comment was left in the source I believe either a) my patch should 
> be applied or b) a new patch with the comment removed should be put in 
> since it's no longer correct. I did not think this type of change to 
> kernel abi was generally acceptable.
> 
> While the commit is over a year old, it changes behavior which had been 
> in tact for a while (years?) from what I can tell. We were running 3.0 
> with stable updates until we upgraded to 3.2 and hit this. Neither of 
> these are what I would consider "old" kernels.
> 

Yes, this is difficult.  Removing existing entries is more likely to
cause damage than adding new ones, so I suspect the safest approach is
to just leave things as they now are.

In which case yes, we should repair that comment.  ie: change it to a
comment which explains *why* we display removable devices.  Unlike the
existing comment which tells us "what" but not "why", when "why" is
what we wanted to know, sigh.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2AEVNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:13:51 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53074 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2AEVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:13:49 -0500
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jan 2012 16:13:49 EST
Date: Thu, 5 Jan 2012 22:07:52 +0100
From: Adrian Reber <adrian@lisas.de>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        "matt.helsley@gmail.com" <matt.helsley@gmail.com>,
        Peter =?iso-8859-1?Q?V=E4terlein?= 
	<Peter.Vaeterlein@hs-esslingen.de>
Subject: Re: linux-cr ported to 3.2-rc1
Message-ID: <20120105210752.GC12072@lisas.de>
References: <20111114151300.GT16442@lisas.de>
 <4EC131A3.9050504@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC131A3.9050504@parallels.com>
X-Url: <http://lisas.de/~adrian/>
X-Operating-System: Linux (2.6.35.13-92.fc14.x86_64)
X-Load-Average: 2.02 1.59 1.59
X-Unexpected: The Spanish Inquisition
X-GnuPG-Key: gpg --recv-keys 3ED6F034
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 07:20:03PM +0400, Pavel Emelyanov wrote:
> On 11/14/2011 07:13 PM, Adrian Reber wrote:
> > I have ported the linux-cr patches from www.linux-cr.org/pub/git/linux-cr.git
> > to the latest kernel (3.2-rc1). The tests (on x86_64) I have done so far
> > were successful. My repository with the C/R patches on top of 3.2-rc1 is
> > currently at:
> > 
> > http://lisas.de/~adrian/linux-cr.git
> > 
> > 
> > The development on the linux-cr tree hast stopped sometime around 2.6.37
> > and although those patches have gone through many revisions I am not sure
> > about the latest state of those patches concerning inclusion. At what
> > point has the discussion stopped and why?
> 
> AFAIK very few people from the community support the idea of having the C/R
> functionality implemented as the kernel subsystem.

Ah. Okay. I still ported those patches to 3.2 so that there exists a
working C/R until you have released your code.

http://lisas.de/~adrian/cr/3.2/linux-cr.git

> > I have seen patches from Pavel about another approach for 
> > checkpointing/restarting but I haven't heard anything about
> > that during the last months.
> > 
> > What are the chances to get one of the checkpointing/restarting
> > implementations included. What is still missing from the one I used?
> 
> The chances are ... quite high. We implement our C/R code in the userspace
> and require very few pieces from kernel. So far 2 out of 3 proposed API
> extensions were merged into -mm tree.
> 
> > What is the latest state of Pavel's patches?
> 
> The state right now is - we can dump and restore tasks with any types of
> memory, open regular files and pipes with its contents. The code is currently 
> under internal review process. We're going to send the public RFC early next 
> week. Then go on with more resources to dump and restore.

I am interested in C/R and if your code has better chances going
upstream then I would be interested seeing those patches and working
with you. As long as I do not have your code I will keep on working with
the patches I currently have and which seem to be running pretty good on
3.2 so far.

The first set of patches in my current patchset tries to implement
eclone() which provides the clone() functionality but with the
possibility to request a certain PID so that child processes can be
restarted with the same PID. How are you planning to restart child
processes? Are those patches maybe something which makes also sense for
your C/R implementation?

		Adrian

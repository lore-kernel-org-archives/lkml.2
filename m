Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0JMMHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:07:12 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5728 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab0JMMHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:07:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOI7tUx5Lc/f/2dsb2JhbAChS3K6b4VIBI9A
Date: Wed, 13 Oct 2010 23:07:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101013120706.GB5883@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <1286966556.3876.261.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286966556.3876.261.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 12:42:36PM +0200, Eric Dumazet wrote:
> Le mercredi 13 octobre 2010 à 18:20 +1100, Nick Piggin a écrit :
> 
> > I don't think the patchset has suddenly become vastly more urgent
> > in the past month, so I think my approach of having it get a lot
> > of testing and go in Al's vfs tree for a while is best.
> > 
> 
> Hi Nick 
> 
> Not vastly urgent, but highly wanted on many workloads, even ones not
> really related to 'fs'...
> 
> In current tree, a "close(socket())" needs 31 us on a 2x4x2 machine,
> instead of 1.45 us if single thread.
> 
> But yes, I agree a lot of testing is needed :)

Hi Eric,

Yes of course I know you know about this :) And google knows about it
too -- they of course posted the batched iput/dput patches a couple of
years back when they noticed it on their socket workloads. I've
extensively tested the socket paths during development of the patches,
and on a POWER7 system with many hundreds of threads, it scales
completely linearly!

I acknowledge that the vfs scale work is actually quite urgent, and
probably at least a year overdue (2.6.32 would have been nice target
for distros). I just mean that it hasn't suddenly gone from less to
much more important to push this in now before I review it or before
it has had a chance in vfs tree.

Thanks,
Nick


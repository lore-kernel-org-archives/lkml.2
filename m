Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab0ECQmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:42:54 -0400
Received: from tex.lwn.net ([70.33.254.29]:41285 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab0ECQmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:42:53 -0400
Date: Mon, 3 May 2010 10:42:50 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: mgross@linux.intel.com, aili@codeaurora.org, dwalker@codeaurora.org,
       tiwai@suse.de, bruce.w.allan@intel.com, davidb@quicinc.com,
       mcgrof@gmail.com, pavel@ucw.cz,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]PM QOS refresh against next-20100430
Message-ID: <20100503104250.7605d2bc@bike.lwn.net>
In-Reply-To: <87y6g1547o.fsf@deeprootsystems.com>
References: <20100430212043.GA30315@linux.intel.com>
	<20100503103300.6330e522@bike.lwn.net>
	<87y6g1547o.fsf@deeprootsystems.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 May 2010 09:40:11 -0700
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> > One question, though...  one clear use of this API is for drivers to
> > say "don't go into C3 or deeper because things go wrong"; I'm about to
> > add another one of those.  It works, but the use of a
> > PM_QOS_CPU_DMA_LATENCY requirement with a hard-coded number that one
> > hopes is small enough seems a bit...indirect.  I wonder if it would be
> > clearer and more robust to add a new requirement^Wrequest type saying
> > "the quality of service I need is shallow sleeps only"?  
> 
> The problem with that is portability.
> 
> What does "shallow" mean?  

Well, shallow could mean that the state lacks the CPUIDLE_FLAG_DEEP
flag; that should be relatively portable.  In any case, it seems more
so than "if I put in a 55us latency requirement, I'll stay out of C3".

Just a thought, anyway; it's not like I've really worked through a
plausible alternative API.

jon

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1HZSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:25:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1HZSZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:25:26 -0400
Date: Fri, 26 Aug 2011 14:25:22 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: VM: add would_have_oomkilled sysctl
Message-ID: <20110826182522.GB2720@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20110826161422.GB30573@redhat.com>
 <alpine.DEB.2.00.1108261117550.13943@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108261117550.13943@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:21:20AM -0700, David Rientjes wrote:
 > On Fri, 26 Aug 2011, Dave Jones wrote:
 > 
 > > At various times in the past, we've had reports where users have been
 > > convinced that the oomkiller was too heavy handed. I added this sysctl
 > > mostly as a knob for them to see that the kernel really doesn't do much better
 > > without killing something.
 > > 
 > 
 > The page allocator expects that the oom killer will kill something to free 
 > memory so it takes a temporary timeout and then retries the allocation 
 > indefinitely.  We never oom kill unless we are going to retry 
 > indefinitely, otherwise it wouldn't be worthwhile.
 > 
 > That said, the only time the oom killer doesn't actually do something is 
 > when it detects an exiting thread that will hopefully free memory soon or 
 > when it detects an eligible thread that has already been oom killed and 
 > we're waiting for it to exit.  So this patch will result in an endless 
 > series of unratelimited printk's.
 > 
 > Not sure that's very helpful.

It's an old patch, and the oom-killer heuristics have improved since then,
as this didn't used to be the case.  Regardless, I'll just drop it from Fedora.

thanks,

	Dave

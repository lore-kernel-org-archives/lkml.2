Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161081Ab2GLNnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:43:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:39097 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161017Ab2GLNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:43:52 -0400
Date: Thu, 12 Jul 2012 15:43:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
In-Reply-To: <1342100270.7707.20.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1207121542510.32033@ionos>
References: <1342072060.7338.102.camel@marge.simpson.net>  <1342082648.7338.171.camel@marge.simpson.net>  <1342086792.7707.9.camel@marge.simpson.net>  <alpine.LFD.2.02.1207121310420.32033@ionos>  <1342094233.7707.12.camel@marge.simpson.net> 
 <alpine.LFD.2.02.1207121514240.32033@ionos> <1342100270.7707.20.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, Mike Galbraith wrote:
> On Thu, 2012-07-12 at 15:31 +0200, Thomas Gleixner wrote: 
> > A quick check for memcpy finds that __btrfs_close_devices() does a
> > memcpy of btrfs_device structs w/o initializing the lock in the new
> > copy, but I have no idea whether that's the place we are looking for.
> 
> 
> Cool, you found one, thanks!  I'm setting boobytraps.
> 
> Um, correction, box says I'm setting _buggy_ boobytraps :)
> 
> Tomorrow-man will test this and frob traps anew.

What kind of test setup do you have? i.e. raid, single disk ...

Thanks,

	tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869Ab2GLNv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:51:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57336 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932387Ab2GLNv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:51:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Hv/RboAMHh0WvCUChr1MEc3+XM3tXPdHUitjLOo
	Of30+Qkq3uKbE+
Message-ID: <1342101083.7707.22.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 12 Jul 2012 15:51:23 +0200
In-Reply-To: <1342100889.7707.21.camel@marge.simpson.net>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <1342082648.7338.171.camel@marge.simpson.net>
	 <1342086792.7707.9.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207121310420.32033@ionos>
	 <1342094233.7707.12.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207121514240.32033@ionos>
	 <1342100270.7707.20.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207121542510.32033@ionos>
	 <1342100889.7707.21.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 15:48 +0200, Mike Galbraith wrote: 
> On Thu, 2012-07-12 at 15:43 +0200, Thomas Gleixner wrote: 
> > On Thu, 12 Jul 2012, Mike Galbraith wrote:
> > > On Thu, 2012-07-12 at 15:31 +0200, Thomas Gleixner wrote: 
> > > > A quick check for memcpy finds that __btrfs_close_devices() does a
> > > > memcpy of btrfs_device structs w/o initializing the lock in the new
> > > > copy, but I have no idea whether that's the place we are looking for.
> > > 
> > > 
> > > Cool, you found one, thanks!  I'm setting boobytraps.
> > > 
> > > Um, correction, box says I'm setting _buggy_ boobytraps :)
> > > 
> > > Tomorrow-man will test this and frob traps anew.
> > 
> > What kind of test setup do you have? i.e. raid, single disk ...
> 
> Yeah, megaraid sas.. x3550 M3.

(one disk for OS, one disk for xfstests to mangle)


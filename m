Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2BVBms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:42:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2BVBmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:42:47 -0500
Date: Tue, 21 Feb 2012 20:42:43 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: Large slowdown with 'x86: Avoid invoking RCU when CPU is idle'
Message-ID: <20120222014242.GF23186@zod.bos.redhat.com>
References: <20120222011652.GE23186@zod.bos.redhat.com>
 <20120222013252.GZ2375@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222013252.GZ2375@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 05:32:52PM -0800, Paul E. McKenney wrote:
> On Tue, Feb 21, 2012 at 08:16:53PM -0500, Josh Boyer wrote:
> > Hi Paul,
> > 
> > Over in Fedora land, I applied your patch from this thread:
> > 
> > https://lkml.org/lkml/2012/1/24/441
> > 
> > to our 3.3-rc3/rc4 based rawhide kernels.  The intention was to solve an
> > RCU issue that was very similar to what Eric originally reported, and
> > the RCU splat did indeed go away[1].
> > 
> > However, we then got a few reports of kernels containing that patch
> > being extremely slow.  When the patch was dropped, the slowness goes
> > away according to one reporter.  The details can be found in this bug:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=795050
> > 
> > The slowness doesn't seem to hit everyone, and in my local testing
> > things seem to be working just fine.  The reporters have widely varying
> > hardware as well, so it doesn't seem machine specific.
> > 
> > Perhaps I misdiagnosed the original issue, or perhaps I missed something
> > else that needs to be applied prior to this but I thought I would point
> > this out in case you had any ideas.

First off, thanks for the quick reply!

> This patch has been obsoleted by patches #45-47 in this series:
> 
> 	https://lkml.org/lkml/2012/2/3/459

Holy lots of patches... 

> And patch #47 in that series has been obsoleted by another series
> from Steven Rostedt:
> 
> 	https://lkml.org/lkml/2012/2/7/231

Ok.

> Hopefully these fix both splats and slowness.

So again, I'm slightly confused on how RCU patches flow.  Eric
originally reported the bug for which you created the patch I applied
against 3.3.  The giant patch series above seems queued for 3.4.

I don't see stable CC'd on 45-47, nor any of Steven's patches.  I doubt
I'd want to go applying the 47-patch series on 3.3 at the moment, and
given you have these marked for 3.4 I don't think you do either.
However, is there some kind of fix for the original bug report against
3.3?

josh

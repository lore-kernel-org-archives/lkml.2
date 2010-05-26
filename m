Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515Ab0EZWdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:33:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44909 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673Ab0EZWdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:33:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH 2/8] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Thu, 27 May 2010 00:34:44 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Len Brown <len.brown@intel.com>, Jim Collar <jim.collar@eqware.net>,
       linux-doc@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Magnus Damm <damm@igel.co.jp>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1005261815480.1328-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005261815480.1328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005270034.44492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Alan Stern wrote:
> On Wed, 26 May 2010, Rafael J. Wysocki wrote:
> 
> > On Wednesday 26 May 2010, Peter Zijlstra wrote:
> > > On Fri, 2010-05-21 at 15:46 -0700, Arve Hjønnevåg wrote:
> > > > +To create a suspend blocker from user space, open the suspend_blocker
> > > > special
> > > > +device file:
> > > > +
> > > > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> > > > +
> > > > +then optionally call:
> > > > +
> > > > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_SET_NAME(strlen(name)), name);
> > > > +
> > > > +To activate the suspend blocker call:
> > > > +
> > > > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
> > > > +
> > > > +To deactivate it call:
> > > > +
> > > > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
> > > > +
> > > > +To destroy the suspend blocker, close the device:
> > > > +
> > > > +    close(fd);
> > > 
> > > Urgh, please let the open() be BLOCK, the close() be UNBLOCK, and keep
> > > the SET_NAME thing if you really care.
> > 
> > SET_NAME wouldn't serve any purpose in that case.
> > 
> > This whole thing is related to the statistics part, which Arve says is
> > essential to him.  He wants to collect statistics for each suspend blocker
> > activated and deactivated so that he can tell who's causing problems by
> > blocking suspend too often.  The name also is a part of this.
> > 
> > In fact, without the statistics part the whole thing might be implemented
> > as a single reference counter such that suspend would happen when it went down
> > to zero.
> 
> There's also Arve's other main point: These suspend blockers tend to
> get used quite a lot.  Opening and closing a file each time has much
> higher overhead than a simple ioctl.
> 
> All these topics have been covered earlier in this discussion.  Peter 
> should go back and read the emails in the linux-pm archive.

Yeah.

Although with a reference counter the special device file won't be necessary.

Rafael

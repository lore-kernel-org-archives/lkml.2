Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0CXE6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:58:44 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:52552 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0CXE6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:58:31 -0400
Date: Wed, 24 Mar 2010 00:57:46 -0400 (EDT)
From: Oren Laadan <orenl@cs.columbia.edu>
X-X-Sender: orenl@takamine.ncl.cs.columbia.edu
To: Matt Helsley <matthltc@us.ibm.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Christoffer Dall <christofferdall@christofferdall.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [C/R ARM][PATCH 1/3] ARM: Rudimentary syscall interfaces
In-Reply-To: <20100324020342.GB5704@count0.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.1003240055050.5867@takamine.ncl.cs.columbia.edu>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
 <1269219965-23923-2-git-send-email-christofferdall@christofferdall.dk>
 <20100323205342.GA19572@n2100.arm.linux.org.uk> <20100324020342.GB5704@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010, Matt Helsley wrote:

> On Tue, Mar 23, 2010 at 08:53:42PM +0000, Russell King - ARM Linux wrote:
> > On Sun, Mar 21, 2010 at 09:06:03PM -0400, Christoffer Dall wrote:
> > > This small commit introduces a global state of system calls for ARM
> > > making it possible for a debugger or checkpointing to gain information
> > > about another process' state with respect to system calls.
> > 
> > I don't particularly like the idea that we always store the syscall
> > number to memory for every system call, whether the stored version is
> > used or not.
> > 
> > Since ARM caches are generally not write allocate, this means mostly
> > write-only variables can have a higher than expected expense.
> > 
> > Is there not some thread flag which can be checked to see if we need to
> > store the syscall number?
> 
> Perhaps before we freeze the task we can save the syscall number on ARM.
> The patches suggest that the signal delivery path -- which the freezer
> utilizes -- has the syscall number already.
> 
> Should work since the threads must be frozen first anyway.

I like the idea.

However, would it also work for those cases when the freezing does not 
occur from the signal delivery path - e.g. for vfork and ptraced tasks ?

Oren.

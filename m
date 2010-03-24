Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0CXCDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:03:50 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36957 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0CXCDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:03:49 -0400
Date: Tue, 23 Mar 2010 19:03:42 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoffer Dall <christofferdall@christofferdall.dk>,
       Roland McGrath <roland@redhat.com>,
       containers <containers@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [C/R ARM][PATCH 1/3] ARM: Rudimentary syscall interfaces
Message-ID: <20100324020342.GB5704@count0.beaverton.ibm.com>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
 <1269219965-23923-2-git-send-email-christofferdall@christofferdall.dk>
 <20100323205342.GA19572@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323205342.GA19572@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 08:53:42PM +0000, Russell King - ARM Linux wrote:
> On Sun, Mar 21, 2010 at 09:06:03PM -0400, Christoffer Dall wrote:
> > This small commit introduces a global state of system calls for ARM
> > making it possible for a debugger or checkpointing to gain information
> > about another process' state with respect to system calls.
> 
> I don't particularly like the idea that we always store the syscall
> number to memory for every system call, whether the stored version is
> used or not.
> 
> Since ARM caches are generally not write allocate, this means mostly
> write-only variables can have a higher than expected expense.
> 
> Is there not some thread flag which can be checked to see if we need to
> store the syscall number?

Perhaps before we freeze the task we can save the syscall number on ARM.
The patches suggest that the signal delivery path -- which the freezer
utilizes -- has the syscall number already.

Should work since the threads must be frozen first anyway.

Cheers,
	-Matt Helsley

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0CWX5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:57:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42416 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0CWX5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:57:02 -0400
Date: Tue, 23 Mar 2010 20:53:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoffer Dall <christofferdall@christofferdall.dk>
Cc: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [C/R ARM][PATCH 1/3] ARM: Rudimentary syscall interfaces
Message-ID: <20100323205342.GA19572@n2100.arm.linux.org.uk>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk> <1269219965-23923-2-git-send-email-christofferdall@christofferdall.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269219965-23923-2-git-send-email-christofferdall@christofferdall.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 09:06:03PM -0400, Christoffer Dall wrote:
> This small commit introduces a global state of system calls for ARM
> making it possible for a debugger or checkpointing to gain information
> about another process' state with respect to system calls.

I don't particularly like the idea that we always store the syscall
number to memory for every system call, whether the stored version is
used or not.

Since ARM caches are generally not write allocate, this means mostly
write-only variables can have a higher than expected expense.

Is there not some thread flag which can be checked to see if we need to
store the syscall number?

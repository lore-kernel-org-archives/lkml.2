Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1KDJc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:32:29 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:39244 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750880Ab1KDJc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:32:28 -0400
Date: Fri, 4 Nov 2011 09:32:22 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH RFC 4/8] mips: implement syscall restart generically
Message-ID: <20111104093222.GA1633@linux-mips.org>
References: <cover.1319364492.git.jonas@southpole.se>
 <04ce50ed7e9e9a949a3c0b447c3aec0a8c6face4.1319364492.git.jonas@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ce50ed7e9e9a949a3c0b447c3aec0a8c6face4.1319364492.git.jonas@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 12:19:58PM +0200, Jonas Bonn wrote:

> Manipulating task state to effect re-execution of an interrupted syscall
> used to be purely architecture specific code.  However, as most arch's
> were essentially just making minor adjustments to almost identical logic,
> this code could be moved to a common implementation.
> 
> The generic variant introduces the function handle_syscall_restart() to be
> called after get_signal_to_deliver().  The architecture specific register
> manipulations required to effect the actual restart are now implemented
> in the generic syscall interface found in asm/syscall.h
> 
> This patch transitions this architecture's signal handling code over to
> using the generic syscall restart code by:
> 
> i)  Implementing the register manipulations in asm/syscall.h
> ii) Replacing the restart logic with a call to handle_syscall_restart

Nice cleanup.

Any reason why you add empty version of syscall_get_arguments and
syscall_set_version?  A non-functional version that causes a silent
failure is way worse than something that fails at compile time.

  Ralf

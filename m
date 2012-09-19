Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2ISNcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:32:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37439 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2ISNc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:32:27 -0400
Date: Wed, 19 Sep 2012 14:32:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches
 solicited
Message-ID: <20120919133226.GZ13973@ZenIV.linux.org.uk>
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
 <5059B892.4030806@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5059B892.4030806@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 05:50:34PM +0530, Vineet Gupta wrote:

> Hi Al,
> 
> It must be noted that despite having seemingly independent
> __ARCH_WANT_(KERNEL|SYS)_EXECVE, arches which have a kernel syscall trap
> based kernel_execve(), e.g. MIPS, can't implement __ARCH_WANT_SYS_EXECVE
> alone - they need to first convert
> to __ARCH_WANT_KERNEL_EXECVE as well (although it probably doesn't make
> sense for anyone to just implement one - but in terms of staging -
> having only one, breaks stuff IMHO).

Of course - that's the reason for kernel_execve() being pulled into the
mix at all.  Unified sys_execve() relies on not using a trap to do
kernel_execve(); it's not exactly the same thing as having it done
by generic instance in fs/exec.c (e.g. some architectures were already
doing it that way, with their own instances, some in asm glue, some
in C) but it is a prerequisite.

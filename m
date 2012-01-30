Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2A3TZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:25:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51402 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2A3TZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:25:58 -0500
Date: Mon, 30 Jan 2012 19:25:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] um: Use generic io.h
Message-ID: <20120130192552.GL23916@ZenIV.linux.org.uk>
References: <1327512234-22578-1-git-send-email-richard@nod.at>
 <20120130182333.GK23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130182333.GK23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 06:23:33PM +0000, Al Viro wrote:
> On Wed, Jan 25, 2012 at 06:23:53PM +0100, Richard Weinberger wrote:
> > There is no need to implement our own basic io functions.
> > All we need exists already in asm-generic/io.h
> 
> Then just do
> 
> git rm arch/um/include/asm/io.h
> echo 'generic-y += io.h' >>arch/um/include/asm/Kbuild
> git add arch/um/include/asm/Kbuild
> 
> and be done with that.  We are already using generic-y for a bunch of
> headers there...

While we are at it, param.h and pci.h appear to be candidates for the
same treatment, along with delay.h and auxvec.h.  mutex.h as well...
BTW, we probably can kill arch/um/include/asm/asm-offsets.h - everything
in there is using generated/asm-offsets.h directly.

FWIW, I'd probably kill current.h as well - replace get_current() in
arch/um/kernel/process.c with get_current_pid() (i.e. task_pid_nr(current)),
kill HOST_TASK_PID and switch arch/x86/um/bugs_32.c to use of get_current_pid()
and we can switch to asm-generic/current.h just fine.

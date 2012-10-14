Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2JNT4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:56:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43774 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2JNT4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:56:14 -0400
Date: Sun, 14 Oct 2012 20:56:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel Mack <zonque@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [revert request for commit 9fff2fa] Re: [git pull] signals pile 3
Message-ID: <20121014195611.GA2616@ZenIV.linux.org.uk>
References: <20121013005334.GM2616@ZenIV.linux.org.uk>
 <507ADBBB.9090209@gmail.com>
 <20121014164020.GV2616@ZenIV.linux.org.uk>
 <CACTFLAOpcLtHNx-TCHQkUOPNAkTO8EgDhbyZSGQ9ag+Wu_cNRw@mail.gmail.com>
 <20121014172640.GW2616@ZenIV.linux.org.uk>
 <20121014192402.GZ2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121014192402.GZ2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 08:24:03PM +0100, Al Viro wrote:

> Russell, could you recall what those had been about?  I'm not sure if that
> had been oopsable that far back (again, oops scenario is userland stack
> page getting swapped out before we get to start_thread(), leading to
> direct read from an absent page in start_thread() by plain ldr, without
> anything in exception table about that insn), but it looks very odd
> regardless of that problem.

BTW, arm64 has copied that logics, so it also seems to be unsafe and very
odd - there we definitely have only ELF to cope with.  arm64 folks Cc'd...

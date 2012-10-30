Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2J3CFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:05:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49884 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2J3CFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:05:04 -0400
Date: Tue, 30 Oct 2012 02:05:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Will Drewry <wad@chromium.org>,
        Geremy Condra <gcondra@google.com>
Subject: Re: [PATCH 2/4] arch/arm: move secure_computing into trace
Message-ID: <20121030020500.GA2616@ZenIV.linux.org.uk>
References: <1351557682-20983-1-git-send-email-keescook@chromium.org>
 <1351557682-20983-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351557682-20983-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 05:41:20PM -0700, Kees Cook wrote:
> From: Will Drewry <wad@chromium.org>
> 
> There is very little difference in the TIF_SECCOMP and TIF_SYSCALL_TRACE
> path in entry-common.S. In order to add support for
> CONFIG_HAVE_ARCH_SECCOMP_FILTER without mangling the assembly too badly,
> seccomp was moved into the syscall_trace_enter() handler.
> 
> Additionally, the return value for secure_computing() is now checked
> and a -1 value will result in the system call being skipped.

This is too ugly.  Just expand the calls of ptrace_syscall_trace() into
both callers and do secure_computing() hookup in there.  And for pity
sake, would somebody rename the damn thing?  It's *dripping* with
marketdroidese...

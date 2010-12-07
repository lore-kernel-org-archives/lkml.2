Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0LGAK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:10:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab0LGAK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:10:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 16/16] ptrace: remove the extra wake_up_process() from ptrace_detach()
In-Reply-To: Tejun Heo's message of  Monday, 6 December 2010 17:57:04 +0100 <1291654624-6230-17-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
	<1291654624-6230-17-git-send-email-tj@kernel.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20101207001043.13BCE400CE@magilla.sf.frob.com>
Date: Mon,  6 Dec 2010 16:10:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The plain wake_up_process was certainly wrong from the beginning.

We were conservative about changing it because of the difficulty of
chasing all the corners where userland debuggers' behavior might be
made to regress when it had been reliable in practice before (even
if not always in theory, such as possible races that didn't bite in
reality).  The userland code has gone to many contortions to cope
with how the kernel behaved in the past, whether or not that
behavior ever made any good sense.

For that sort of reason, none of this stuff should change at all in
a -stable kernel, nor late in a release cycle.

For new kernels, I think changing the behavior in the direction of
something that can actually be described is OK as long as userland
debugger maintainers like Jan agree to the new behavior and that the
behavior really and truly does follow an articulated set of rules
that the kernel and userland sides agree to.


Thanks,
Roland

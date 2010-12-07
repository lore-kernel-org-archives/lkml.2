Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0LGNob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 08:44:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:60785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0LGNoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:44:30 -0500
Message-ID: <4CFE39EC.40907@kernel.org>
Date: Tue, 07 Dec 2010 14:43:08 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 16/16] ptrace: remove the extra wake_up_process() from
 ptrace_detach()
References: <1291654624-6230-1-git-send-email-tj@kernel.org>	<1291654624-6230-17-git-send-email-tj@kernel.org> <20101207001043.13BCE400CE@magilla.sf.frob.com>
In-Reply-To: <20101207001043.13BCE400CE@magilla.sf.frob.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 13:43:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roland.

On 12/07/2010 01:10 AM, Roland McGrath wrote:
> The plain wake_up_process was certainly wrong from the beginning.
> 
> We were conservative about changing it because of the difficulty of
> chasing all the corners where userland debuggers' behavior might be
> made to regress when it had been reliable in practice before (even
> if not always in theory, such as possible races that didn't bite in
> reality).  The userland code has gone to many contortions to cope
> with how the kernel behaved in the past, whether or not that
> behavior ever made any good sense.
> 
> For that sort of reason, none of this stuff should change at all in
> a -stable kernel, nor late in a release cycle.

Sure, definitely.  All these changes are at the earliest for the next
merge window.

> For new kernels, I think changing the behavior in the direction of
> something that can actually be described is OK as long as userland
> debugger maintainers like Jan agree to the new behavior and that the
> behavior really and truly does follow an articulated set of rules
> that the kernel and userland sides agree to.

Yeap, that sounds good to me.

Thanks.

-- 
tejun

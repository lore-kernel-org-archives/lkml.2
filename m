Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2LUHVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 02:21:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50025 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LUHVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 02:21:04 -0500
Date: Fri, 21 Dec 2012 07:20:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jim Cromie <jim.cromie@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] Ensure that kernel_init_freeable() is not inlined
 into non __init code
Message-ID: <20121221072056.GS4939@ZenIV.linux.org.uk>
References: <1356072944-23800-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356072944-23800-1-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 12:25:44PM +0530, Vineet Gupta wrote:
> Commit d6b2123802d "make sure that we always have a return path from
> kernel_execve()" reshuffled kernel_init()/init_post() to ensure that
> kernel_execve() has a caller to return to.
> 
> It removed __init annotation for kernel_init() and introduced/calls a
> new routine kernel_init_freeable(). Latter however is inlined by any
> reasonable compiler (ARC gcc 4.4 in this case), causing slight code
> bloat.

Interesting...  I assumed that explicitly set different section would be
enough, but I'd been wrong (or the original noinline would've been pointless,
now that I think of it).  Consider it ACKed; I can pick it through signal.git,
and while it's not urgent I'd send it to Linus after -rc1, with Cc: stable.
Or you can send it to him yourself with my usual Acked-by - up to you.

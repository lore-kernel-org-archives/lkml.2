Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab1EQQW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:22:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab1EQQW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:22:27 -0400
Date: Tue, 17 May 2011 12:22:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 01/10] signal: remove three noop tracehooks
Message-ID: <20110517162224.GA13675@infradead.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 08:17:20PM +0200, Tejun Heo wrote:
> Remove the following three noop tracehooks in signals.c.
> 
> * tracehook_force_sigpending()
> * tracehook_get_signal()
> * tracehook_finish_jctl()
> 
> The code area is about to be updated and these hooks don't do anything
> other than obfuscating the logic.

Btw, I think we should kill that stupid <linux/tracehook.h> layer
entirely.  It consists of a few relatively useful function which should
just be renamed to ptrace_* and moved to ptrace.c, and a lot of entirely
pointless wrappers which generally have only a single user, and often
tons of arguments that aren't actually used.


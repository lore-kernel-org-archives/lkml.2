Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0IVFoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:44:19 -0400
Received: from ozlabs.org ([203.10.76.45]:35319 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab0IVFoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:44:18 -0400
Date: Wed, 22 Sep 2010 15:44:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-arch@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: powerpc: fix double syscall restarts
Message-ID: <20100922054410.GA22365@drongo>
References: <20100920204856.GF31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920204856.GF31363@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 09:48:57PM +0100, Al Viro wrote:

> Make sigreturn zero regs->trap, make do_signal() do the same on all
> paths.  As it is, signal interrupting e.g. read() from fd 512 (==
> ERESTARTSYS) with another signal getting unblocked when the first
> handler finishes will lead to restart one insn earlier than it ought
> to.  Same for multiple signals with in-kernel handlers interrupting
> that sucker at the same time.  Same for multiple signals of any kind
> interrupting that sucker on 64bit...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Paul Mackerras <paulus@samba.org>

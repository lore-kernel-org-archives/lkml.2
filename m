Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2JAPgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:36:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64266 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2JAPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:36:48 -0400
Date: Mon, 1 Oct 2012 17:36:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] x86/microcode changes for v3.7
Message-ID: <20121001153643.GA25751@gmail.com>
References: <20121001142439.GA24959@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001142439.GA24959@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Linus,
> 
> Please pull the latest x86-microcode-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus
> 
>    HEAD: bd13178169d5fd17da3221b55ba313270393649a Merge tag 'microcode_fix_3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/microcode
> 
> The biggest changes are to AMD microcode patching: add code 
> for caching all microcode patches which belong to the current 
> family on which we're running, in the kernel. We look up the 
> patch needed for each core from the cache at patch-application 
> time instead of holding a single patch per-system.

Something I forgot to mention: doing it this way is beneficial 
for suspend/resume and is generally the modern way of doing a 
self-sufficient in-kernel driver.

The natural next step will be to extend this approach to Intel 
CPUs (there's nothing inherently AMD specific about it) - that 
is still work in progress and was not ready for this merge 
window.

Just in case someone is wondering.

Thanks,

	Ingo

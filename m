Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1J0Tew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 15:34:52 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:42794 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1J0Tev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 15:34:51 -0400
Date: Thu, 27 Oct 2011 21:34:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
Message-ID: <20111027193448.GA3514@merkur.ravnborg.org>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 02:07:14PM +0200, Sasha Levin wrote:
> This patch adds 'make kvmconfig' which allows to add KVM guest support
> to a config file.
> 
> This allows for easier testing of configurations under virtualized
> environments.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: linux-kbuild@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Two points about the implmentation that I do not like...

The kvmconfig is an x86 specific thing - so it does not belong
in the scripts/kconfig/Makefile

The *config namespace is general config targets.

Suggestion:
Move the implmentation to arch/x86/Makefile and name the target
something that does not match the *config pattern.

Suggestion:

   make kvmbootable

To tell that this convert the current config to a kvmbootable config.

And then add the target to the x86 specific help too.

	Sam

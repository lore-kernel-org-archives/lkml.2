Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2EEP62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:58:28 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:31822 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab2EEP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:58:27 -0400
Date: Sat, 5 May 2012 17:58:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/18] fork: Remove the weak insanity
Message-ID: <20120505155824.GA14468@merkur.ravnborg.org>
References: <20120505150007.543515803@linutronix.de> <20120505150141.306358267@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120505150141.306358267@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 03:05:40PM -0000, Thomas Gleixner wrote:
> We error out when compiling with gcc4.1.[01] as it miscompiles
> __weak. The workaround with magic defines is not longer
> necessary. Make it __weak again.

The cleanup is much appreciated!

But the magic defines is IMO much better than the CONFIG_ based approach
that this patch-set introduces in the last patch.

If you do:

    $git grep arch_task_cache_init

Then if you see:

    #define arch_task_cache_init arch_task_cache_init

Then you know alrady that this arch will provide a local implementation
of arch_task_cache_init().
No need to grep for an ARCH_XXX symbol that you need to look up
somewhere else.

	Sam

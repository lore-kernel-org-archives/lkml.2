Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965951Ab0GPQFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:05:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55708 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965891Ab0GPQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:05:01 -0400
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for
 defconfig
From: Catalin Marinas <catalin.marinas@arm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <20100713230352.6781.18644.stgit@angua>
References: <20100713230352.6781.18644.stgit@angua>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 16 Jul 2010 17:03:41 +0100
Message-ID: <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2010 16:03:41.0924 (UTC) FILETIME=[75F26A40:01CB2500]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 00:04 +0100, Grant Likely wrote:
> - It still doesn't resolve dependencies.  A solver would help with this.
>   For the time being I work around the problem by running the generated
>   config through 'oldconfig' and looking for differences.  If the files
>   differ (ignoring comments and generateconfig_* options) after oldconfig,
>   then the <board>_defconfig target returns a failure.  (but leaves the
>   new .config intact so the user can resolve it with menuconfig).  This
>   way at least the user is told when a Kconfig fragment is invalid.

It's not a solver but I'm pushing a patch to warn on selecting symbols
with unmet dependencies so that you can select further symbols (manual
solving). The patch is in linux-next but you also can grab it from:

http://git.kernel.org/?p=linux/kernel/git/cmarinas/linux-2.6-cm.git;a=commitdiff_plain;h=5d87db2d2a332784bbf2b1ec3e141486f4d41d6f

-- 
Catalin


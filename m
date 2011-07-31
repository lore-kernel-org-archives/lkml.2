Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1GaUUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 16:20:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:58372 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1GaUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 16:20:46 -0400
Subject: Re: [PATCH] kbuild: honor the ARCH setting of the existing
 configuration
From: David Woodhouse <dwmw2@infradead.org>
To: Aunt Tillie <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Sun, 31 Jul 2011 21:20:42 +0100
In-Reply-To: <1312141497-13854-1-git-send-email-lacombar@gmail.com>
References: <1312141497-13854-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1312143643.12369.32.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 15:44 -0400, Aunt Tillie wrote:
> This change make Kbuild honor the ARCH setting of the existing configuration, if
> any .config is present so that it does not get reset if there is a conflict
> with the default ARCH for the platform and the current setting.

I think this is the wrong approach.

There are plans to make the architecture a *real* configuration option,
and that will be lovely when it happens (and changing the 32-vs-64
distinction so that it's no longer a different ARCH but just a config
option is one step in that direction).

But I don't think this patch is really a helpful step towards that goal;
we should do that *properly* or not at all, and not give some temporary
half-baked behaviour in the meantime, that people will come to depend on
(and others will hate because it means they can't just take an ARM
config and build it on their x86 box and have it automatically
converted).

And the other problem is that this is not really addressing the
underlying issue, which is that we are still clinging to the legacy ARCH
values for directories which don't exist in the arch/ directory any
more, and which are *redundant* with the setting of CONFIG_64BIT in the
config.

The only problem here is that we're not using the merged ARCH=x86 by
default, as most of the other 64-bit capable architectures in the kernel
do — and it works just fine for all of them.

If the x86 merge still hasn't been completed, four years after we
deleted arch/{i386,x86_64}, then we need to complete it. Thanks for
helping to root out the few esoteric things that still don't quite work
right on x86; it's very useful to find them and fix them.

-- 
dwmw2


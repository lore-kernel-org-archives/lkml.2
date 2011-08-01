Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab1HAIgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:36:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50611 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1HAIg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:36:26 -0400
Date: Mon, 1 Aug 2011 09:36:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Zoltan Devai <zdevai@gmail.com>
Cc: linux-kernel@vger.kernel.org, chris@zankel.net, linux-am33-list@redhat.com,
        trivial@kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        cmetcalf@tilera.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Remove remaining references of CONFIG_GENERIC_TIME
Message-ID: <20110801083614.GC15578@n2100.arm.linux.org.uk>
References: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 06:14:38PM +0200, Zoltan Devai wrote:
> Commit 592913ecb87a9e06f98ddb55b298f1a66bf94c6b has killed off any
> use of this config option long ago.

I don't see the point of this - we were free of GENERIC_TIME on ARM
shortly after it was originally killed off.  The problem is you can't
stop people introducing new uses of this - because it existed once and
there's nothing which errors out on its presence, people are going to
continue submitting patches with it in.  And it's going to continue
being missed at the review stage.

I've a similar problem with folk on ARM including mach/gpio.h as their
sole gpio header file rather than linux/gpio.h - I've been trying for
the last 1-2 years to educate people to use linux/ in preference.  You
can't do it, and I'm still just about the only one who picks up on that.
(SoC maintainers don't care.)  They will end up caring when I push a
change during the next merge window though, so I'll eventually stop
mach/gpio.h being included.  (Instead, it'll be asm/gpio.h).

GENERIC_TIME though... I don't think you'll ever stop new uses of it
creeping in unless you can arrange for something to error out.

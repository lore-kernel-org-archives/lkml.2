Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0G1VWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:22:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36721 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab0G1VWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:22:20 -0400
Date: Wed, 28 Jul 2010 22:21:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, stepanm@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100728212156.GA6729@n2100.arm.linux.org.uk>
References: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org> <201007281039.44883.arnd@arndb.de> <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org> <201007281950.20847.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007281950.20847.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 07:50:20PM +0200, Arnd Bergmann wrote:
> The DMA API is extremely flexible, it works just fine with all the
> IOMMUs that I've seen so far. Please take a look at
> include/asm-generic/dma-mapping-common.h and its users to see how
> to use multiple IOMMUs depending on the device.

We don't yet use those DMA API interface extensions because we haven't
had the need.  If someone who has the need wants to put the effort in
though...

One of the problems with it though is the abstraction of the sync*
operations is the wrong way around for stuff like dmabounce - we want
to be passed the base address of the buffer (so we can look this up),
plus offset and length.  We don't want to know just the region which
is affected.

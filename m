Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0K2VyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:54:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45266 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752475Ab0K2VyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:54:22 -0500
Date: Mon, 29 Nov 2010 21:53:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] asm-generic: Raise default NR_IRQS when using sparse
 IRQs
Message-ID: <20101129215134.GA8335@opensource.wolfsonmicro.com>
References: <fUhqx-3EE-15@gated-at.bofh.it>
 <4CF406ED.6070705@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF406ED.6070705@pavlinux.ru>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:02:53PM +0300, Pavel Vasilyev wrote:
> On 29.11.2010 22:20, Mark Brown wrote:
> > Rather than have each platform using sparse IRQs pick a suitably large
> > NR_IRQS for use with sparse IRQs make the default high when they are
> > enabled.  We pick 64k as there is still a bitmap of IRQs that is
> > allocated statically, and as we all know 64k should be enough for
> > anyone.

> May be

>   #define NR_IRQS 15*NR_CPUS

No, this is missing the point - that's way too low for many systems
(most except x86 I guess).  The idea is that since we're using sparse
IRQs we've much less reason to restrict the number of IRQs than we do
when we've got a statically allocated table so we can have a higher
default, meaning less need for platforms to individually select a higher
number.

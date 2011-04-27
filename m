Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069Ab1D0Vp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:45:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:43020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759270Ab1D0Vp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:45:57 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
References: <201104212129.17013.arnd@arndb.de>
	 <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 07:45:37 +1000
Message-ID: <1303940737.2513.190.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 10:52 +0100, Catalin Marinas wrote:
> 
> It's not broken since we moved to using Normal non-cacheable memory
> for the coherent DMA buffers (as long as you flush the cacheable alias
> before using the buffer, as we already do). The ARM ARM currently says
> unpredictable for such situations but this is being clarified in
> future updates and the Normal non-cacheable vs cacheable aliases can
> be used (given correct cache maintenance before using the buffer).

Don't you have a risk where speculative loads or prefetches might bring
back some stuff into the cache via the cachable mapping ? Is that an
issue ? As long as it's non-dirty and the cachable mapping isn't
otherwise used, I suppose it might be a non-issue, tho I've seen in
powerpc land cases of processors that can checkstop if a subsequent non
cachable access "hits" the stuff that was loaded in the cache.

Cheers,
Ben.



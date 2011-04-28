Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1D1IbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:31:21 -0400
Received: from service87.mimecast.com ([94.185.240.25]:33719 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754618Ab1D1IbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:31:18 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303940737.2513.190.camel@pasglop>
References: <201104212129.17013.arnd@arndb.de>
	 <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
	 <1303940737.2513.190.camel@pasglop>
Organization: ARM Limited
Date: Thu, 28 Apr 2011 09:31:12 +0100
Message-ID: <1303979472.26744.6.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 28 Apr 2011 08:31:12.0956 (UTC) FILETIME=[A20B27C0:01CC057E]
X-MC-Unique: 111042809311502601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 22:45 +0100, Benjamin Herrenschmidt wrote:
> On Wed, 2011-04-27 at 10:52 +0100, Catalin Marinas wrote:
> > It's not broken since we moved to using Normal non-cacheable memory
> > for the coherent DMA buffers (as long as you flush the cacheable alias
> > before using the buffer, as we already do). The ARM ARM currently says
> > unpredictable for such situations but this is being clarified in
> > future updates and the Normal non-cacheable vs cacheable aliases can
> > be used (given correct cache maintenance before using the buffer).
> 
> Don't you have a risk where speculative loads or prefetches might bring
> back some stuff into the cache via the cachable mapping ? Is that an
> issue ? As long as it's non-dirty and the cachable mapping isn't
> otherwise used, I suppose it might be a non-issue, tho I've seen in
> powerpc land cases of processors that can checkstop if a subsequent non
> cachable access "hits" the stuff that was loaded in the cache.

At the CPU cache level, unexpected cache hit is considered a miss, IOW
non-cacheable memory accesses ignore the cache lines that may have been
speculatively loaded.

-- 
Catalin



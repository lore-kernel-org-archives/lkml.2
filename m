Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1LSGRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:17:04 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:49513 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab1LSGRC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:17:02 -0500
MIME-Version: 1.0
In-Reply-To: <201112121648.52126.arnd@arndb.de>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
 <20111209142405.6f371be6@pyramind.ukuu.org.uk> <CAKMK7uH+4uSYYjBLcvfhVC+iwGUZ09Z4p64fNBzh196aG+hqgg@mail.gmail.com>
 <201112121648.52126.arnd@arndb.de>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Mon, 19 Dec 2011 11:46:40 +0530
Message-ID: <CAB2ybb_dU7BzJmPo6vA92pe1YCNerCLc+bv7Qi_EfkfGaik6bQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer
 sharing mechanism
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, Daniel,

On Mon, Dec 12, 2011 at 10:18 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 10 December 2011, Daniel Vetter wrote:
>> If userspace (through some driver calls)
>> tries to do stupid things, it'll just get garbage. See
>> Message-ID: <CAKMK7uHeXYn-v_8cmpLNWsFY14KtmuRZy8YRKR5Xst2-2WdFSQ@mail.gmail.com>
>> for my reasons why it think this is the right way to go forward. So in
>> essence I'm really interested in the reasons why you want the kernel
>> to enforce this (or I'm completely missing what's the contentious
>> issue here).
>
> This has nothing to do with user space mappings. Whatever user space does,
> you get garbage if you don't invalidate cache lines that were introduced
> through speculative prefetching before you access cache lines that were
> DMA'd from a device.
I didn't see a consensus on whether dma_buf should enforce some form
of serialization within the API - so atleast for v1 of dma-buf, I
propose to 'not' impose a restriction, and we can tackle it (add new
ops or enforce as design?) whenever we see the first need of it - will
that be ok? [I am bending towards the thought that it is a problem to
solve at a bigger platform than dma_buf.]
>
>        Arnd

Best regards,
~Sumit.
>
> --

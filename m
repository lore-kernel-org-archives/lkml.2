Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1DVAeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:34:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43013 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1DVAeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=yBHI7hMyWFE4Aht5DkyOoreTlgcGRcQvgo7qk58EFzWdZoB9N0atYPI43NMTzslPF1
         5QbYz9D4HA5Mefbe4EijAEh3IRvl6eYS1saBDY2PMG3SU8KBzJlgmrxHPj5mIomUcgWf
         L7xywSquT73zAqK3iISbTFOoTqAdZsS4ISVlw=
MIME-Version: 1.0
In-Reply-To: <BANLkTim5umALqafjA2e88UCLzMp9LQu3_Q@mail.gmail.com>
References: <201104212129.17013.arnd@arndb.de>
	<20110421130930.4be9e9e1@jbarnes-desktop>
	<BANLkTim5umALqafjA2e88UCLzMp9LQu3_Q@mail.gmail.com>
Date: Fri, 22 Apr 2011 09:34:00 +0900
X-Google-Sender-Auth: iH1vnr-ti67jYxPzf3-gSZFL23c
Message-ID: <BANLkTimz8zprEw7H_i8g2qj8RyyougiBBw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: KyongHo Cho <pullip.cho@samsung.com>
To: Zach Pfeffer <zach.pfeffer@linaro.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Ilho Lee <ilho215.lee@samsung.com>, sanghyun75.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 6:52 AM, Zach Pfeffer <zach.pfeffer@linaro.org> wrote:
>
> I agree with Jesse that the separation of mapping from allocation is
> central to the current usage models. I realize most people didn't like
> VCMM, but it provided an abstraction for this - if software can handle
> the multiple mapper approach in a rational way across ARM than we can
> solve a lot of problems with all the map and unmap current solutions
> and we don't have to hack in coherency.
>

Hi.
I've also noticed that VCMM is the reasonable idea for IOMMU mappings.
We often deal with physical memory blocks to map multiple way.
Allocation of physical memory itself is also important for some
peripheral devices
because it is beneficial to get larger page frame for their performance.

IOMMU api does not provide virtual memory management.
DMA api is not flexible for all our use-cases.

Regards,
KyongHo.

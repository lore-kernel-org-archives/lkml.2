Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab1FGK3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:29:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52791 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1FGK3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:29:15 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.65.238]
In-Reply-To: <201106071105.16262.laurent.pinchart@ideasonboard.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <1307053663-24572-3-git-send-email-ohad@wizery.com> <201106071105.16262.laurent.pinchart@ideasonboard.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 7 Jun 2011 13:28:53 +0300
Message-ID: <BANLkTi=nJXSEfWRXqwnHys1b5i5rgLcYpw@mail.gmail.com>
Subject: Re: [RFC 2/6] omap: iovmm: generic iommu api migration
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, arnd@arndb.de, davidb@codeaurora.org,
        Joerg.Roedel@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Jun 7, 2011 at 12:05 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> pgsz isn't used anymore, you can remove it.

Ok.

>> +             order = get_order(bytes);
>
> Does iommu_map() handle offsets correctly, or does it expect pa to be aligned
> to an order (or other) boundary ?

Right now we have a BUG_ON if pa is unaligned, but that can be changed
if needed (do we want it to handle offsets ?).

> As Russell pointed out, we should use sg->length instead of sg_dma_length(sg).
> sg_dma_length(sg) is only valid after the scatter list has been DMA-mapped,
> which doesn't happen in the iovmm driver. This applies to all sg_dma_len(sg)
> calls.

I'll make sure I don't introduce such calls, but it sounds like a
separate patch should take care of the existing ones; pls tell me if
you want me to send one.

Thanks,
Ohad.

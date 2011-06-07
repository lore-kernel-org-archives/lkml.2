Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1FGNqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:46:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45575 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1FGNqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:46:47 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.65.238]
In-Reply-To: <201106071326.53106.laurent.pinchart@ideasonboard.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <201106071105.16262.laurent.pinchart@ideasonboard.com> <BANLkTi=nJXSEfWRXqwnHys1b5i5rgLcYpw@mail.gmail.com>
 <201106071326.53106.laurent.pinchart@ideasonboard.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 7 Jun 2011 16:46:26 +0300
Message-ID: <BANLkTimqt=yMGHcqEH5u-4GkMX9=+BuB6A@mail.gmail.com>
Subject: Re: [RFC 2/6] omap: iovmm: generic iommu api migration
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, arnd@arndb.de, davidb@codeaurora.org,
        Joerg.Roedel@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Jun 7, 2011 at 2:26 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> Right now we have a BUG_ON if pa is unaligned, but that can be changed
>> if needed (do we want it to handle offsets ?).
>
> At least for the OMAP3 ISP we need to, as video buffers don't necessarily
> start on page boundaries.

Where do you take care of those potential offsets today ? Or do you
simply ignore the offsets and map the entire page ?

Seems like omap's iommu (mostly) rejects unaligned pa addresses, see:

4abb761749abfb4ec403e4054f9dae2ee604e54f "omap iommu: Reject unaligned
addresses at setting page table entry"

(this doesn't seem to cover 4KB entries though, only large pages,
sections and super sections)

> A separate patch is indeed needed, yes. As you're already working on iommu it
> might be simpler if you add it to your tree.

Sure, i'll send it.

Thanks,
Ohad.

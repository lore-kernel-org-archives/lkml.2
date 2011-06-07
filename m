Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1FGM2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:28:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43015 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab1FGM2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:28:16 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.65.238]
In-Reply-To: <201106071340.15199.laurent.pinchart@ideasonboard.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <201106071122.47804.laurent.pinchart@ideasonboard.com> <BANLkTineGVvmph=Om2FGR_+mkiMW6k7UAw@mail.gmail.com>
 <201106071340.15199.laurent.pinchart@ideasonboard.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 7 Jun 2011 15:27:55 +0300
Message-ID: <BANLkTikGvCDhOev02=n3H1pQvF69fn1uuw@mail.gmail.com>
Subject: Re: [RFC 1/6] omap: iommu: generic iommu api migration
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, arnd@arndb.de, davidb@codeaurora.org,
        Joerg.Roedel@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 2:40 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> My point is that if the allocator guarantees the alignment (not as a side
> effect of the implementation, but per its API) there's no need to check it
> again. As the alignement is required, we need an allocator that guarantees it
> anyway.

I understand, but I'd still prefer to have an explicit check that the
hardware alignment requirement is met.

There's no cost in doing that (it's a cold path), and even if it would
only fail once and with an extremely broken kernel - it's worth it.
Will save huge amount of debugging pain (think of the poor guy that
will have to debug this...).

Thanks,
Ohad.

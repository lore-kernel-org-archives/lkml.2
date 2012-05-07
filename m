Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2EGX5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:57:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:15651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451Ab2EGX5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:57:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97424442"
From: Andi Kleen <andi@firstfloor.org>
To: =?utf-8?Q?St=C3=A9phane?= Marchesin <marcheu@chromium.org>
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com,
        torvalds@linux-foundation.org, seanpaul@chromium.org,
        olofj@chromium.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] mm: Work around Intel SNB GTT bug with some physical pages.
References: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
Date: Mon, 07 May 2012 16:57:09 -0700
In-Reply-To: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
	(=?utf-8?Q?=22St=C3=A9phane?= Marchesin"'s message of "Mon, 7 May 2012
 16:13:41 -0700")
Message-ID: <m2zk9jlf3e.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stéphane Marchesin <marcheu@chromium.org> writes:

> While investing some Sandy Bridge rendering corruption, I found out
> that all physical memory pages below 1MiB were returning garbage when
> read through the GTT. This has been causing graphics corruption (when
> it's used for textures, render targets and pixmaps) and GPU hangups
> (when it's used for GPU batch buffers).

It would be possible to exlude GFP_DMA from the page allocator. That
covers the first 16MB. You just need a custom zone list with ZONE_DMA.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

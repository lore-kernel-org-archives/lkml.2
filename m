Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0KXASB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:18:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34764 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab0KXASA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:18:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [RFC PATCH] fadvise support in rsync
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        rsync@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <1290523792-6170-1-git-send-email-bgamari.foss@gmail.com>
References: <20101122103756.E236.A69D9226@jp.fujitsu.com> <1290523792-6170-1-git-send-email-bgamari.foss@gmail.com>
Message-Id: <20101124090749.7BE8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 24 Nov 2010 09:17:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is my attempt at adding fadvise support to rsync (against v3.0.7). I do
> this in both the sender (hinting after match_sums()) and the receiver (hinting
> after receive_data()). In principle we could get better granularity if this was
> hooked up within match_sums() (or even the map_ptr() interface) and the receive
> loop in receive_data(), but I wanted to keep things simple at first (any
> comments on these ideas?) . At the moment is for little more than testing.
> Considering the potential negative effects of using FADV_DONTNEED on older
> kernels, it is likely we will want this functionality off by default with a
> command line flag to enable.

Great!

As far as you don't hesitate userland app, we have no reason to hesitate
kernel change. We are only worry about to create no user interface. Because
it's maintainance nightmare.




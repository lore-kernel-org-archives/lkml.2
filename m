Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2DHLj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 07:39:29 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:45057 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2DHLj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 07:39:28 -0400
Date: Sun, 8 Apr 2012 13:39:25 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>
Subject: BUG: Bad rss-counter state
Message-ID: <20120408113925.GA292@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've hit the following warning after I've tried to link Firofox's libxul
with "-flto -lto-partition=none" on my machine with 8GB memory. I've
killed the process after it used all the memory and 90% of my swap
space. Before the machine was rebooted I saw these messages:

Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020813c380 idx:1 val:-1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020813c380 idx:2 val:1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88021503bb80 idx:1 val:-1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff8801fb643b80 idx:1 val:-1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff8801fb643b80 idx:2 val:1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88021503bb80 idx:2 val:1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020a4ff800 idx:1 val:-1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020a4ff800 idx:2 val:1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020813ce00 idx:1 val:-1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020813ce00 idx:2 val:1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff8801fadda680 idx:1 val:-1
Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff8801fadda680 idx:2 val:1

These warnings were introduced by c3f0327f8e9d7. Wouldn't it make sense to hide
them under some debugging option? AFAICS they contain no information that could
be of any use to a casual user.

-- 
Markus

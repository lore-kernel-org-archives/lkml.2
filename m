Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1GUSH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:07:27 -0400
Received: from waste.org ([173.11.57.241]:41333 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1GUSH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:07:26 -0400
Subject: Nanosecond fs timestamp support: sad
From: Matt Mackall <mpm@selenic.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 13:07:21 -0500
Message-ID: <1311271641.14555.114.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it turns out that the resolution on filesystem timestamps is tied to
HZ rather than gettimeofday or similar, which means the resolution
improvement over seconds is.. not much. And not nearly as much as
advertised!

This means I can touch a file something like 70k times per second and
get only 300 distinct timestamps on my laptop. And only 100 distinct
timestamps on a typical distro server kernel.

Meanwhile, I can call gettimeofday 35M times per second and get ~1M
distinct responses.

Given that we can do gettimeofday three orders of magnitude faster than
we can do file transactions and it has four orders of magnitude better
resolution, shouldn't we be using it for filesystem time when
sb->s_time_gran is less than 1/HZ?

-- 
Mathematics is the supreme nostalgia of our time.



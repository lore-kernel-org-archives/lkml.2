Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2GIUxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:53:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2GIUxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:53:30 -0400
Date: Mon, 9 Jul 2012 13:53:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: Warn about costly page allocation
Message-Id: <20120709135329.40fbfe20.akpm@linux-foundation.org>
In-Reply-To: <20120709131942.GA3594@barrios>
References: <1341801500-5798-1-git-send-email-minchan@kernel.org>
	<20120709082200.GX14154@suse.de>
	<20120709084657.GA7915@bbox>
	<20120709091203.GY14154@suse.de>
	<20120709125048.GA2203@barrios>
	<20120709130551.GA14154@suse.de>
	<20120709131942.GA3594@barrios>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012 22:19:42 +0900
Minchan Kim <minchan@kernel.org> wrote:

> > As you are using printk_ratelimit()

include/linux/printk.h sayeth

/*
 * Please don't use printk_ratelimit(), because it shares ratelimiting state
 * with all other unrelated printk_ratelimit() callsites.  Instead use
 * printk_ratelimited() or plain old __ratelimit().
 */


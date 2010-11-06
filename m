Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0KFBEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 21:04:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:45682 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab0KFBEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 21:04:20 -0400
Date: Sat, 6 Nov 2010 02:03:57 +0100
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Greg Thelen <gthelen@google.com>, Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: use do_div to divide s64 in 32 bit machine.
Message-ID: <20101106010357.GD23393@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
11;rgb: 0000/0000/0000From: Johannes Weiner <hannes@cmpxchg.org>
From: hannes@cmpxchg.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 01:08:53AM +0900, Minchan Kim wrote:
> Use do_div to divide s64 value. Otherwise, build would be failed
> like Dave Young reported.

I thought about that too, but then I asked myself why you would want
to represent a number of pages as signed 64bit type, even on 32 bit?

Isn't the much better fix to get the types right instead?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0KLI3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:29:41 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:37016 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0KLI3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:29:41 -0500
Date: Fri, 12 Nov 2010 09:29:21 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] memcg: make mem_cgroup_page_stat() return value
 unsigned
Message-ID: <20101112082921.GH9131@cmpxchg.org>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
 <1289294671-6865-7-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289294671-6865-7-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 01:24:31AM -0800, Greg Thelen wrote:
> mem_cgroup_page_stat() used to return a negative page count
> value to indicate value.

Whoops :)

> mem_cgroup_page_stat() has changed so it never returns
> error so convert the return value to the traditional page
> count type (unsigned long).

This changelog feels a bit beside the point.

What's really interesting is that we now don't consider negative sums
to be invalid anymore, but just assume zero!  There is a real
semantical change here.

That the return type can then be changed to unsigned long is a nice
follow-up cleanup that happens to be folded into this patch.

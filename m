Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1JCXL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:11:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46521 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1JCXLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:11:52 -0400
Date: Mon, 3 Oct 2011 16:11:49 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] memcg naturalization -rc4
Message-Id: <20111003161149.bc458294.akpm00@gmail.com>
In-Reply-To: <1317330064-28893-1-git-send-email-jweiner@redhat.com>
References: <1317330064-28893-1-git-send-email-jweiner@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 23:00:54 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> this is the fourth revision of the memory cgroup naturalization
> series.

The patchset removes 20 lines from include/linux/*.h and removes
exactly zero lines from mm/*.c.  Freaky.

If we were ever brave/stupid emough to make
CONFIG_CGROUP_MEM_RES_CTLR=y unconditional, how much could we simplify
mm/?

We are adding bits of overhead to the  CONFIG_CGROUP_MEM_RES_CTLR=n case
all over the place.  This patchset actually decreases the size of allnoconfig
mm/built-in.o by 1/700th.

A "struct mem_cgroup" sometimes gets called "mem", sometimes "memcg",
sometimes "mem_cont".  Any more candidates?  Is there any logic to
this?


Anyway...  it all looks pretty sensible to me, but the timing (at
-rc8!) is terrible.  Please keep this material maintained for -rc1, OK?

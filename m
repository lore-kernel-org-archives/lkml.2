Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1HRHAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:00:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46170 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1HRHAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:00:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Aug 2011 15:52:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
Message-Id: <20110818155234.e8afee9b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1313650253-21794-1-git-send-email-gthelen@google.com>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 23:50:53 -0700
Greg Thelen <gthelen@google.com> wrote:

> Both mem_cgroup_charge_statistics() and mem_cgroup_move_account() were
> unnecessarily disabling preemption when adjusting per-cpu counters:
>     preempt_disable()
>     __this_cpu_xxx()
>     __this_cpu_yyy()
>     preempt_enable()
> 
> This change does not disable preemption and thus CPU switch is possible
> within these routines.  This does not cause a problem because the total
> of all cpu counters is summed when reporting stats.  Now both
> mem_cgroup_charge_statistics() and mem_cgroup_move_account() look like:
>     this_cpu_xxx()
>     this_cpu_yyy()
> 
> Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>

Thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


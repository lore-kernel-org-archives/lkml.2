Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2DJAhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:37:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38691 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab2DJAhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:37:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F838051.50101@jp.fujitsu.com>
Date: Tue, 10 Apr 2012 09:35:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] mm: sync rss-counters at the end of exit_mm()
References: <20120409200336.8368.63793.stgit@zurg>
In-Reply-To: <20120409200336.8368.63793.stgit@zurg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/10 5:03), Konstantin Khlebnikov wrote:

> On task's exit do_exit() calls sync_mm_rss() but this is not enough,
> there can be page-faults after this point, for example exit_mm() ->
> mm_release() -> put_user() (for processing tsk->clear_child_tid).
> Thus there may be some rss-counters delta in current->rss_stat.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Does this fix recent issue reported ?

 




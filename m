Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2DJFnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:43:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32818 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2DJFnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:43:18 -0400
Message-ID: <4F83C870.2090100@openvz.org>
Date: Tue, 10 Apr 2012 09:43:12 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] mm: sync rss-counters at the end of exit_mm()
References: <20120409200336.8368.63793.stgit@zurg> <4F838051.50101@jp.fujitsu.com>
In-Reply-To: <4F838051.50101@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> (2012/04/10 5:03), Konstantin Khlebnikov wrote:
>
>> On task's exit do_exit() calls sync_mm_rss() but this is not enough,
>> there can be page-faults after this point, for example exit_mm() ->
>> mm_release() ->  put_user() (for processing tsk->clear_child_tid).
>> Thus there may be some rss-counters delta in current->rss_stat.

I had to mention it in comment:

This should fix warnings:
BUG: Bad rss-counter state mm:ffff88020813c380 idx:1 val:-1
BUG: Bad rss-counter state mm:ffff88020813c380 idx:2 val:1

>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> Reported-by: Markus Trippelsdorf<markus@trippelsdorf.de>
>> Cc: Hugh Dickins<hughd@google.com>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> Reviewed-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> Does this fix recent issue reported ?
>

I hope so.

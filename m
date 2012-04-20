Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2DTUmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2DTUmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:42:13 -0400
Date: Fri, 20 Apr 2012 22:41:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] mm: set task exit code before complete_vfork_done()
Message-ID: <20120420204129.GA8034@redhat.com>
References: <20120409200336.8368.63793.stgit@zurg> <20120412080948.26401.23572.stgit@zurg> <20120412235446.GA4815@redhat.com> <20120420175934.GA31905@redhat.com> <4F91B7AF.8040203@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F91B7AF.8040203@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Konstantin Khlebnikov wrote:
>
> Oleg Nesterov wrote:
>>
>> 	/* sync mm's RSS info before statistics gathering */
>> 	if (tsk->mm)
>> 		sync_mm_rss(tsk->mm);
>>
>> Which "statistics gathering" ? Probably I missed something, but
>> after the quick grep it seems to me that this is only needed for
>> taskstats_exit()->xacct_add_tsk().
>>
>> So why we can't simply add sync_mm_rss() into xacct_add_tsk() ?
>
>> Yes, this way we do not "account" put_user(clear_child_tid) but
>> I think we do not care.
>
> Why we don't care? Each thread can corrupt these counters by one.
> I do not think that we are satisfied with nearly accurate rss accounting.
> +/- one page for each clone()-exit().

Not actually "for each" in practice. Each exit does sync_ (with
this patch from xacct_add_tsk), the net effect should be small.

And. This is what we do now, nobody ever complained.

>> IOW, what do you think about the trivial patch below? Uncompiled,
>> untested, probably incomplete. acct_update_integrals() looks
>> suspicious too.
>
> what a mess! =)

Thanks ;)

But it is much, much simpler than your patches, don't you agree?

Oleg.


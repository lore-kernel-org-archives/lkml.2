Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291Ab2DLXz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:55:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab2DLXzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:55:25 -0400
Date: Fri, 13 Apr 2012 01:54:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] mm: set task exit code before complete_vfork_done()
Message-ID: <20120412235446.GA4815@redhat.com>
References: <20120409200336.8368.63793.stgit@zurg> <20120412080948.26401.23572.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412080948.26401.23572.stgit@zurg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Konstantin Khlebnikov wrote:
>
> kthread_stop() uses task->vfork_done for synchronization. The exiting kthread
> shouldn't do complete_vfork_done() until it sets ->exit_code.
>
> fix for mm-correctly-synchronize-rss-counters-at-exit-exec.patch

Yes, this should fix the problem with kthread_stop()...

Damn, Konstantin I have to admit, I'll try to find another technical
reason against mm-correctly-synchronize-rss-counters-at-exit-exec.patch
even with this fix ;)

Most probably I am wrong, but it looks overcomplicated. Somehow I
dislike irrationally the fact you moved mm_release() from exit_mm().

But, once again, it is not that I see the better solution.

2/2 looks fine at first glance... and afaics it is "off-topic".

Oleg.


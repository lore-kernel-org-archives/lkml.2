Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186Ab2FHRDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761333Ab2FHRDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:03:47 -0400
Date: Fri, 8 Jun 2012 19:01:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [patch 12/12] mm: correctly synchronize rss-counters at
	exit/exec
Message-ID: <20120608170152.GA30975@redhat.com>
References: <20120607212114.E4F5AA02F8@akpm.mtv.corp.google.com> <CA+55aFxOWR_h1vqRLAd_h5_woXjFBLyBHP--P8F7WsYrciXdmA@mail.gmail.com> <CA+55aFyQUBXhjVLJH6Fhz9xnpfXZ=9Mej5ujt6ss7VUqT1g9Jg@mail.gmail.com> <alpine.LSU.2.00.1206071759050.1291@eggly.anvils> <4FD1D1F7.2090503@openvz.org> <20120608122459.GB23147@redhat.com> <4FD1FE20.40600@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD1FE20.40600@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08, Konstantin Khlebnikov wrote:
>
> Oleg Nesterov wrote:
>> On 06/08, Konstantin Khlebnikov wrote:
>>>
>>> As result you can see "BUG: Bad rss-counter state mm:ffff88040783a680 idx:1 val:-1" in dmesg
>>>
>>> There left only one problem: nobody calls sync_mm_rss() after put_user() in mm_release().
>>
>> Both callers call sync_mm_rss() to make check_mm() happy. But please
>> see the changelog, I think we should move it into mm_release(). See
>> the patch below (on top of v2 I sent). I need to recheck.
>
> Patch below broken: it removes one hunk from kernel/exit.c twice.
> And it does not add anything into mm_release().

Yes, sorry. But I guess you understand the intent, mm_release() should
simply do sync_mm_rss() after put_user(clear_child_tid) unconditionally.

If task->mm == NULL but task->rss_stat, then there is something wrong
and probably OOPS makes sense.

Oleg.


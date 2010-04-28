Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab0D1IR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 04:17:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:51210 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0D1IRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 04:17:24 -0400
Date: Wed, 28 Apr 2010 16:15:45 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
Message-ID: <20100428081545.GA19027@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com>
 <u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com>
 <q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Apr 2010 08:15:48.0183 (UTC) FILETIME=[020F3E70:01CAE6AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 03:52:01PM +0800, Changli Gao wrote:
> On Wed, Apr 28, 2010 at 3:47 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> > On Wed, Apr 28, 2010 at 1:03 PM, Changli Gao <xiaosuo@gmail.com> wrote:
> >> implement the exclusive wait queue as a LIFO queue
> >>
> >> If the exclusive wait queue is also a LIFO queue as the normal wait queue, the
> >> process who goes to sleep recently, will be woke up first. As its memory is
> >> more likely in cache, we will get better performance. And when there are many
> >> processes waiting on a exclusive wait queue, some of them may not be woke up,
> >> if the others can handle the workload, and it will reduce the load of
> >> the scheduler.
> >>
> >
> > Starve some processes for performance?
> >
> 
> Starve? Oh, No. If we don't need these processes, and we can do better

What do you mean "we don't need these processes"?

> without them, why we wake them up?

So some processs(at the tail of exclusive list)will be treated abnormally
and it will sleep for a long time, is this reasonable?

> 
> 
> -- 
> Regards，
> Changli Gao(xiaosuo@gmail.com)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

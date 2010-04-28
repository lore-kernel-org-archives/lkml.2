Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0D1LRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:17:51 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:46276 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab0D1LRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XYgljjBWDRX5EH0a403oW5civnVA9oK4ukxWN/COcTAtczJdN0OVBDAxoSO2TAAnKe
         gWXuwv2Ibh5CiyrQlXZWh2L4epaPCxEotJSe6uba6lGR81qtIhCWu2SuB+DmmwaNyUC6
         IdSunuyemwB59jbw2k46LZgLvPJD+4pvwfkbI=
MIME-Version: 1.0
In-Reply-To: <8482.1272446987@redhat.com>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> 
	<u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com> 
	<q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com> 
	<20100428081545.GA19027@windriver.com> <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com> 
	<8482.1272446987@redhat.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 28 Apr 2010 19:17:29 +0800
Message-ID: <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com>
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
To: David Howells <dhowells@redhat.com>
Cc: Yong Zhang <yong.zhang@windriver.com>, Xiaotian Feng <xtfeng@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 5:29 PM, David Howells <dhowells@redhat.com> wrote:
> Changli Gao <xiaosuo@gmail.com> wrote:
>
>> If there isn't enough work to be done, we'd better not disrupt them
>> and  leave them sleeping forever to keep the scheduler happier. Do we
>> have reason to keep fair to all the workers? Does it have benefit?
>
> You've made one important assumption: the processes on the wait queue are
> sleeping waiting to service things... but what if the wait queue governs
> access to a resource, and all the processes on that wait queue need access to
> that resource to do things?  Some of the processes waiting for it may never
> get a go, and so necessary work may be left undone.
>

You are right. I made the wrong assumption. But we indeed need some
primitive to add wait_queue at the head of the wait_queue_head, and I
know epoll needs it, at least.

fs/eventpoll.c: 1443.
                wait.flags |= WQ_FLAG_EXCLUSIVE;
                __add_wait_queue(&ep->wq, &wait);

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0D1N4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:56:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60933 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0D1N4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hecs/ImhyGiG6xNaHMV4du2z15x4gAIePiGyR5fr/qGr+fcrXVR174dhqijqwrDPe7
         w33zGNxsaZ0ATM+cAJqeF0GWlTBqzrPnRzlWqk2N+1nCVkVULAGueaBWSOxMl+U0sQLi
         fYeQnTpInl2PPbPPFVPysPFPjvQya+3owRbiw=
MIME-Version: 1.0
In-Reply-To: <8526.1272447122@redhat.com>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> 
	<8526.1272447122@redhat.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 28 Apr 2010 21:56:29 +0800
Message-ID: <q2r412e6f7f1004280656t331e9120rc9eab069fb4d4de3@mail.gmail.com>
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>,
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

On Wed, Apr 28, 2010 at 5:32 PM, David Howells <dhowells@redhat.com> wrote:
> Changli Gao <xiaosuo@gmail.com> wrote:
>
>> @@ -50,6 +48,7 @@ struct wait_bit_queue {
>>  struct __wait_queue_head {
>>       spinlock_t lock;
>>       struct list_head task_list;
>> +     struct list_head task_list_ex;
>
> It would be preferable it if you could avoid making struct __wait_queue_head
> bigger.  That will increase the size of a lot of things.
>

I don't know how to do that, as maybe there are non-exclusive and
exclusive wait queues in the same wait queue head. If we want to
enqueue exclusive wait queues at the head of exclusive queues, we have
to know where the head is, otherwise, we have to loop to find the head
when enqueuing.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)

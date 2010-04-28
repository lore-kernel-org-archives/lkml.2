Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0D1HwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:52:24 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:60427 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0D1HwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BcYfPqP/YX+ic5Iu6lAQ0reGKzyigvDSf1PHomMwRkZY4maNQy1KxJWWE5P1vPg2BO
         MhoqZtP4DVJ7yB+io9WevSNW98BSC+IVhKK2wy90Ax+4Ldx1BkY59WYp/njhM55bjjjz
         ESNf4YCxWV79qeE+9iJuefRSy+XFwk9W6PGCc=
MIME-Version: 1.0
In-Reply-To: <u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> 
	<u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 28 Apr 2010 15:52:01 +0800
Message-ID: <q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com>
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
To: Xiaotian Feng <xtfeng@gmail.com>
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
       Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 3:47 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Wed, Apr 28, 2010 at 1:03 PM, Changli Gao <xiaosuo@gmail.com> wrote:
>> implement the exclusive wait queue as a LIFO queue
>>
>> If the exclusive wait queue is also a LIFO queue as the normal wait queue, the
>> process who goes to sleep recently, will be woke up first. As its memory is
>> more likely in cache, we will get better performance. And when there are many
>> processes waiting on a exclusive wait queue, some of them may not be woke up,
>> if the others can handle the workload, and it will reduce the load of
>> the scheduler.
>>
>
> Starve some processes for performance?
>

Starve? Oh, No. If we don't need these processes, and we can do better
without them, why we wake them up?


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)

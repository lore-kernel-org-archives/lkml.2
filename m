Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab0D1IYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 04:24:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57340 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0D1IYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 04:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FA1wGKD4W7/LWxK/0sh+oTt5h7J8FyRYbBviA9jOS+fr/FyqUpsI6O4/dSU0vCDsCz
         REUkc7PeMinGlgB8EtN4Y2+N0xrZv2lvX6TplpPmYBZe9NSV1wXEmK0Turvh93OttbSh
         9Y9nAcL/IcjgG5KGqLpvDD41VfYCrUO1Iv6nA=
MIME-Version: 1.0
In-Reply-To: <20100428081545.GA19027@windriver.com>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> 
	<u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com> 
	<q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com> 
	<20100428081545.GA19027@windriver.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 28 Apr 2010 16:23:52 +0800
Message-ID: <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com>
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
To: Yong Zhang <yong.zhang@windriver.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 4:15 PM, Yong Zhang <yong.zhang@windriver.com> wrote:
>
> What do you mean "we don't need these processes"?

If the work is less than the workers, we don't need the workers at the
tail of the exculsive list.

>
>> without them, why we wake them up?
>
> So some processs(at the tail of exclusive list)will be treated abnormally
> and it will sleep for a long time, is this reasonable?
>

If there isn't enough work to be done, we'd better not disrupt them
and  leave them sleeping forever to keep the scheduler happier. Do we
have reason to keep fair to all the workers? Does it have benefit?

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)

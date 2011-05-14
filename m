Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1ENLMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 07:12:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab1ENLMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 07:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=C2y//lb4KllNb7mOBjjqPxUTRS9BY4JGNN1vBdQwJwRnPTo+Pw20Dj0ukSlDvHH8d7
         R8w6Hb1gznWHyqMSxgFbyMqznYKB2zV5TIDG26uBbr5ltYH1XjlWK8rFGOA9y6RKhAGP
         G7JGBI+0GlAI77kDwa5YXGGC1GPSbalJDiGgc=
MIME-Version: 1.0
In-Reply-To: <1305311276.2680.34.camel@work-vm>
References: <1305241371-25276-1-git-send-email-john.stultz@linaro.org>
 <1305241371-25276-2-git-send-email-john.stultz@linaro.org>
 <4DCD1256.4070808@jp.fujitsu.com> <1305311276.2680.34.camel@work-vm>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sat, 14 May 2011 20:12:10 +0900
X-Google-Sender-Auth: y8ctBkaLOSTeX0vrcGxcvPAr7nA
Message-ID: <BANLkTin_MitzRUkWToj055AuAPdMC9msXQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock seqlock to protect
 task->comm access
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Can you please explain why we should use seqlock? That said,
>> we didn't use seqlock for /proc items. because, plenty seqlock
>> write may makes readers busy wait. Then, if we don't have another
>> protection, we give the local DoS attack way to attackers.
>
> So you're saying that heavy write contention can cause reader
> starvation?

Yes.

>> task->comm is used for very fundamentally. then, I doubt we can
>> assume write is enough rare. Why can't we use normal spinlock?
>
> I think writes are likely to be fairly rare. Tasks can only name
> themselves or sibling threads, so I'm not sure I see the risk here.

reader starvation may cause another task's starvation if reader have
an another lock.
And, "only sibling" don't make any security gurantee as I said past.

Thanks.

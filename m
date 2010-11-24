Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0KXQrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:47:15 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45580 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab0KXQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NzBQBoQBDO9Xo2Gn6TNdvcfh6MjksSrRIGSQZSGuCqoyI+vA86gDCuEAuKbc4yp5fH
         sft3UtBpjBSAtmcqAFrelXljzwyXV703i4rI1ERz9/3Ot+VZOWesRM4BafPH9TnXyzT3
         d2G/CEpBHefFILEmwWSrIr09M+0TrqG1qcVuA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011241042100.16025@router.home>
References: <20101123235139.908255844@linux.com>
	<20101123235201.758191189@linux.com>
	<AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com>
	<alpine.DEB.2.00.1011241012180.14268@router.home>
	<AANLkTikxrvbDJ=rDhj=gC-FJTa1Jeky1uLWjnP6VF_pX@mail.gmail.com>
	<alpine.DEB.2.00.1011241042100.16025@router.home>
Date: Wed, 24 Nov 2010 18:47:12 +0200
X-Google-Sender-Auth: ycBrTId9L7VSB-iGTdjHr-_rfL8
Message-ID: <AANLkTin02TYMurwmGZi2meSmVg6W4a37qmOLJLrFvMCm@mail.gmail.com>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Pekka Enberg wrote:
>> > The critical section begins with the retrieval of the tid and it ends with
>> > the replacement of the tid with the newly generated one. This means that
>> > all state data for the alloc and free operation needs to be retrieved in
>> > that critical section. The change must be saved with the final
>> > cmpxchg_double of the critical section.
>>
>> Right and we don't need a *memory barrier* here because we're
>> accessing a per-CPU variable which means operations appear in-order.

On Wed, Nov 24, 2010 at 6:45 PM, Christoph Lameter <cl@linux.com> wrote:
> The compiler is still free to rearrange the tid fetch. A possible
> optimization that the compiler may do is to move the tid fetch into the
> next if statement since that is the only block in which the tid variable
> is actually used.

Yes, which is why we need a *compiler barrier* but not a *memory barrier*.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1FGOrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:47:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57171 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab1FGOrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SMtifX5oTNtQWbcPR/DGO1RfWhKiZEtRCwPj92BxVbn19Ou6yMY3SoOvvwNY3dw0IR
         qsvsFLNn/29gdsELkq37PKIfelUWYicEKSauNrkDe7O3qtMlo52o+mdj5YII7tD5Qh1K
         0q3aYfDHJzh0nEl8LnEdDBogqH1j7281tMrW0=
MIME-Version: 1.0
In-Reply-To: <1307457646.2322.273.camel@twins>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	<1307454439.2322.260.camel@twins>
	<BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
	<1307456680.2322.270.camel@twins>
	<BANLkTim1htraTXtGMcyAuH1Wa-G+J05i_g@mail.gmail.com>
	<1307457646.2322.273.camel@twins>
Date: Tue, 7 Jun 2011 22:47:21 +0800
Message-ID: <BANLkTi=XTpYTZvetOUDgobRa_S4Cb=+syA@mail.gmail.com>
Subject: Re: [PATCH] sched: correct testing need_resched in mutex_spin_on_owner()
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 10:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-06-07 at 22:36 +0800, Hillf Danton wrote:
>
>> If you are right, the following comment also in __mutex_lock_common()
>>
>>       for (;;) {
>>               struct task_struct *owner;
>>
>>               /*
>>                * If there's an owner, wait for it to either
>>                * release the lock or go to sleep.
>>                */
>>               owner = ACCESS_ONCE(lock->owner);
>>               if (owner && !mutex_spin_on_owner(lock, owner))
>>                       break;
>>
>> looks misleading too, but if owner is on this CPU, for what does we wait?
>
> huh, wtf!? it cannot be on this cpu, if it was we wouldn't be running
> the above code but whatever owner was doing.
>
> So my argument was, it cannot be on this cpu, therefore, by checking it
> is on a cpu, we check its on a different cpu.
>
> And I really don't see how any of that is related to the above.
>
Oh, it looks you are willing to rethink about testing need_resched?

thanks
           Hillf

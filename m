Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1ECG7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 02:59:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59811 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1ECG7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 02:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OK+0WPs6ZqskpQ7oFR5+A7kguGrEeB1CQNM9u1wiTb+3DJ+uKD1/am8rK+p5h8dYnE
         BCXb2KlW6o428Whmb56V1KANzaIH3HX+SVB7CP1rML9gZAPYz4lBXUdNmt68ykjMABHq
         tVc7upt1aE13Um2sWdLmJyeb+qnnmm7VmNEtA=
Message-ID: <4DBFA7E1.5090501@gmail.com>
Date: Tue, 03 May 2011 10:59:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using cluster
 groups v4
References: <20110502113445.751391656@openvz.org> <20110502114024.222582172@openvz.org> <20110502132232.GA3873@elte.hu> <4DBEB96A.8000309@openvz.org> <4DBEBE72.3040702@gmail.com> <20110502150552.GA21974@elte.hu> <4DBECAB4.7020809@gmail.com> <20110503063130.GC7751@elte.hu>
In-Reply-To: <20110503063130.GC7751@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 10:31 AM, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
>> On 05/02/2011 07:05 PM, Ingo Molnar wrote:
>> ...
>>>>
>>>>   Ingo, would it be fine to make apic->init() either _before_ this series or 
>>>> on top of them (because if I introduce it inside this particular patch it 
>>>> would contain some unrelated code snippets such as .init = NULL for all apics 
>>>> declaration).
>>>
>>> Of course it should be a separate patch - even this patch looks a bit large - 
>>> any way to split it up further?
>>
>>   Well, for this particular path the only minimum is used, so i fear there is no
>> way to split it, probably I could drop some 'cleanup' bits from it and make it
>> a separate one. Gimme some time.
> 
> Well, first try to do *all* preparatory and cleanup changes that have low 
> regression risk.

OK

> 
> *Then* keep the most dangerous part to the end of it - so that it's easily 
> reverted, should the need arise. Preferably the dangerous part should be much 
> smaller than:
> 
>  3 files changed, 136 insertions(+), 46 deletions(-)
> 
> And no, it is not at all true that there is 'no way' to split the patch up any 
> further: you could certainly add the data structures, init methods and such 
> support code (which is low regression risk) in a separate patch than the 
> changes that modify the existing x2apic_send_IPI_mask_allbutself() function and 
> such.

OK

> 
> Also, the loop body in the new __x2apic_send_IPI_mask() function could 
> certainly be split out into a helper inline, making the code flow clearer.

OK, will try so, thanks Ingo!

> 
> Thanks,
> 
> 	Ingo


-- 
Thanks,
  Cyrill

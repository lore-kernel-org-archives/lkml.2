Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab1EBPQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:16:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41389 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab1EBPQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bJ3t3+Y4YegpW8OF3sS0M8bXzY4NhPUvIrVSgUtEcgYWFgLcHm7p2VMPafRRnE9J7f
         y417T7zsuaIk0NhoYrmkg/3nerMBL9tyB+f7Ck/awwnz6nSE81HeTKvhhDsuys1movMq
         paYpaL+xAtkb2iN+y5s1GZA45zq0vQphHRSms=
Message-ID: <4DBECAB4.7020809@gmail.com>
Date: Mon, 02 May 2011 19:16:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using cluster
 groups v4
References: <20110502113445.751391656@openvz.org> <20110502114024.222582172@openvz.org> <20110502132232.GA3873@elte.hu> <4DBEB96A.8000309@openvz.org> <4DBEBE72.3040702@gmail.com> <20110502150552.GA21974@elte.hu>
In-Reply-To: <20110502150552.GA21974@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 07:05 PM, Ingo Molnar wrote:
...
>>
>>   Ingo, would it be fine to make apic->init() either _before_ this series or 
>> on top of them (because if I introduce it inside this particular patch it 
>> would contain some unrelated code snippets such as .init = NULL for all apics 
>> declaration).
> 
> Of course it should be a separate patch - even this patch looks a bit large - 
> any way to split it up further?

  Well, for this particular path the only minimum is used, so i fear there is no
way to split it, probably I could drop some 'cleanup' bits from it and make it
a separate one. Gimme some time.

> 
> And yes, if it fits it should be in apic->probe() instead of introducing a new 
> ->init() method.

  I'll recheck. Thanks for all comments Ingo, drop this series for a while then.

> 
> Thanks,
> 
> 	Ingo


-- 
Thanks,
  Cyrill

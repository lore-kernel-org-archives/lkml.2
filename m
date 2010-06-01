Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab0FAUtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:49:51 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:43239 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0FAUtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bw1Wk2ip+/3iVngNUeV0f0BNiI1FfmQz7kRhoVy3CjsKbJvJREy7Zd1dz8v+3iHlBQ
         f6sqDPttwVHPw5sdF1WCSfO2eQn6DX/n9Heg6gfg45b9iusozSF6uGmM5cLUjiZ8v3hu
         wwYZ0pOXWlC3pyeERxM3eXK7s/5gGhn1Q67ao=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006010842350.3637@i5.linux-foundation.org>
References: <AANLkTilnTVvZOw-bIpcKS0VwhlpYWnnxvOevNv67hnga@mail.gmail.com>
	<alpine.LFD.2.00.1006010842350.3637@i5.linux-foundation.org>
Date: Tue, 1 Jun 2010 21:49:48 +0100
Message-ID: <AANLkTik_SVekWMlhJXvEI0Iao6OTVSBG0tdPBl3PShCj@mail.gmail.com>
Subject: Re: [2.6.35-rc1, patch] fix cpu_chain section mismatch...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jun 1, 2010 at 4:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 1 Jun 2010, Daniel J Blueman wrote:
>>
>> In 2.6.35-rc1, __cpu_notify access cpu_chain, which shouldn't be
>> marked __cpuinitdata (via section mismatch warning).
>
> Hmm. Does this section mismatch go away if you instead mark cpu_notify(),
> __cpu_notify() and cpu_notify_nofail as "inline"? Or alternatively, maybe
> they should all be marked as __ref?

Indeed the inline and __ref approaches quench the warning too.

> I think the section mismatch started happening when those wrapper
> functions were created, but all the callers seem to be __ref or __cpuinit.
>
> Or maybe we should just make that variable be non-cpuinitdata like your
> patch suggests.

At least this is the minimal change until a good reason comes along.

Thanks,
  Daniel

> Does anybody have strong preferences (patch appended for reference)?
>
>                Linus
> ---
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>>
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index 8b92539..97d1b42 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -34,7 +34,7 @@ void cpu_maps_update_done(void)
>>       mutex_unlock(&cpu_add_remove_lock);
>>  }
>>
>> -static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
>> +static RAW_NOTIFIER_HEAD(cpu_chain);
>>
>>  /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
>>   * Should always be manipulated under cpu_add_remove_lock
-- 
Daniel J Blueman

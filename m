Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2BOFIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:08:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62505 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2BOFIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:08:22 -0500
MIME-Version: 1.0
In-Reply-To: <1329281947.2555.26.camel@edumazet-laptop>
References: <1329280586-6878-1-git-send-email-tom.leiming@gmail.com>
	<1329281947.2555.26.camel@edumazet-laptop>
Date: Wed, 15 Feb 2012 13:08:22 +0800
Message-ID: <CACVXFVN7ye6QkJLWSTecy24FeHY6SRB6cDLAXyrPF7kBKgvq5g@mail.gmail.com>
Subject: Re: [PATCH v1] percpu: use raw_local_irq_* in _this_cpu op
From: Ming Lei <tom.leiming@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 12:59 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 15 février 2012 à 12:36 +0800, Ming Lei a écrit :
>> It doesn't make sense to trace irq off or do irq flags
>> lock proving inside 'this_cpu' operations, so replace local_irq_*
>> with raw_local_irq_* in 'this_cpu' op.
> ...
>> Acked-by: Christoph Lameter <cl@linux.com>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  include/linux/percpu.h |   20 ++++++++++----------
>>  1 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
>> index 6e68d05..5ed1e38 100644
>> --- a/include/linux/percpu.h
>> +++ b/include/linux/percpu.h
>> @@ -294,9 +294,9 @@ do {                                                                      \
>>  #define _this_cpu_generic_to_op(pcp, val, op)                                \
>>  do {                                                                 \
>>       unsigned long flags;                                            \
>> -     local_irq_save(flags);                                          \
>> +     raw_local_irq_save(flags);                                              \
>>       *__this_cpu_ptr(&(pcp)) op val;                                 \
>> -     local_irq_restore(flags);                                       \
>> +     raw_local_irq_restore(flags);                                   \
>>  } while (0)
>>
>
> Could you check the alignement of trailing '\' ?

Just several warnings, no errors. Also the 5 warnings are introduced
by previous commit, sounds nothing to do with motivation of this patch.
You may prepare a standalone patch to fix all the code style in this file, :-)

./script/checkpatch.pl
          WARNING: line over 80 characters
          ......
          total: 0 errors, 5 warnings, 60 lines checked


thanks,
-- 
Ming Lei

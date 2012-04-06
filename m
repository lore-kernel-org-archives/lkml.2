Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2DFIdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:33:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49439 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2DFIdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyT7vCjr0-3qdz_0oNVZ+a3K8A7F7aGVVzYtNdUkovp1Q@mail.gmail.com>
References: <1333692989-9230-1-git-send-email-kernelfans@gmail.com>
	<CA+55aFyT7vCjr0-3qdz_0oNVZ+a3K8A7F7aGVVzYtNdUkovp1Q@mail.gmail.com>
Date: Fri, 6 Apr 2012 16:33:20 +0800
Message-ID: <CAFgQCTuxwHDJaR-6NPoFdvQVMQqB3BAtrq2e_HQ0DM8=yL9jLQ@mail.gmail.com>
Subject: Re: [PATCH] pid: remove redundant condition
From: Liu ping fan <kernelfans@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 2:26 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Apr 5, 2012 at 11:16 PM, Liu Ping Fan <kernelfans@gmail.com> wrote:
>> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>>
>> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>> ---
>>  kernel/pid.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/pid.c b/kernel/pid.c
>> index 9f08dfa..e4ca244 100644
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -248,8 +248,7 @@ void put_pid(struct pid *pid)
>>                return;
>>
>>        ns = pid->numbers[pid->level].ns;
>> -       if ((atomic_read(&pid->count) == 1) ||
>> -            atomic_dec_and_test(&pid->count)) {
>> +       if (atomic_dec_and_test(&pid->count) {
>>                kmem_cache_free(ns->pid_cachep, pid);
>>                put_pid_ns(ns);
>>        }
>
> No, this isn't necessarily redundant.
>
> The atomic_dec_and_test() instruction can be very expensive. So if
Oh, got it, thanks.

Regards,
pingfan
> count was 1 before, we're the last user, and we can free it without
> the expensive atomic_dec_and_test().
>
> However, if we are *not* the last user, then we can race with another
> user decrementing the count, so now we need to use the expensive
> version.
>
> Now, whether that special case is really worth it or not, I don't
> know. But it's not redundant.
>
>                    Linus

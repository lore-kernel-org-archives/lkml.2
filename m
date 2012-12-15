Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2LOBxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 20:53:30 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57372 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2LOBx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 20:53:29 -0500
MIME-Version: 1.0
In-Reply-To: <4511257.Msp501Wi5G@vostro.rjw.lan>
References: <1355474528-13094-1-git-send-email-sivaramn@nvidia.com>
	<4511257.Msp501Wi5G@vostro.rjw.lan>
Date: Fri, 14 Dec 2012 17:53:28 -0800
X-Google-Sender-Auth: nMlBc-FswoT5uIMPvNjrPiQRkL0
Message-ID: <CAMbhsRQXAwObH0TL9Kx9pCscQ3r19_KyV9MCMTQ_qYfrxP5XTw@mail.gmail.com>
Subject: Re: [PATCH 1/1] cpuidle: coupled: fix ready counter decrement
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sivaram Nair <sivaramn@nvidia.com>, santosh.shilimkar@ti.com,
        khilman@ti.com, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 3:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, December 14, 2012 10:42:08 AM Sivaram Nair wrote:
>> The ready_waiting_counts atomic variable is compared against the wrong
>> online cpu count. The latter is computed incorrectly using logical-OR
>> instead of bit-OR. This patch fixes that.
>
> I'm queuing this up for submission as v3.8 material.
>
> I suppose it should be marked for -stable too?
>
> Rafael

Acked-by: Colin Cross <ccross@android.com>

Looks suitable for stable.

>> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
>> ---
>>  drivers/cpuidle/coupled.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
>> index 3265844..2a297f8 100644
>> --- a/drivers/cpuidle/coupled.c
>> +++ b/drivers/cpuidle/coupled.c
>> @@ -209,7 +209,7 @@ inline int cpuidle_coupled_set_not_ready(struct cpuidle_coupled *coupled)
>>       int all;
>>       int ret;
>>
>> -     all = coupled->online_count || (coupled->online_count << WAITING_BITS);
>> +     all = coupled->online_count | (coupled->online_count << WAITING_BITS);
>>       ret = atomic_add_unless(&coupled->ready_waiting_counts,
>>               -MAX_WAITING_CPUS, all);
>>
>>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1EaDTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 23:19:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43820 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1EaDTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 23:19:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lYdLF6U1lTpPcF/SrjpKKABuWv94c58GYk/IvgIGGX7hT4eE+huBw5nGrK03pauryI
         82yXG7ofcUf3kmhaYXzcLA5UXJ4OKKFDFbl6Pl8+teNa+zZbTeo8UfGbaE3/EE5Zc5Qk
         nxXMgP07G9knXJ519A4uleTjWVzQ+TB1k4yEI=
MIME-Version: 1.0
In-Reply-To: <4DE45119.9040108@jp.fujitsu.com>
References: <1306774744.4061.5.camel@localhost.localdomain>
	<4DE45119.9040108@jp.fujitsu.com>
Date: Tue, 31 May 2011 09:19:03 +0600
Message-ID: <BANLkTinX0+i=QS_0uL8R-b=-TgzAYEtcEA@mail.gmail.com>
Subject: Re: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
From: Rakib Mullick <rakib.mullick@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 8:23 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index 20c18b7..72cf857 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -461,7 +461,11 @@ void refresh_cpu_vm_stats(int cpu)
>>                               p->expire = 3;
>>  #endif
>>                       }
>> +
>> +#ifndef CONFIG_PREEMPT
>>               cond_resched();
>> +#endif
>> +
>
> In general, we should avoid #ifdef CONFIG_PREEMPT for maintainancebility as far as possible.
> Is there any observable benefit? Can you please demonstrate it?
>
On my system I'm not sure whether it shows demonstratable benefit or
not. Although, I try. It will be helpful if you give me a hint about
how to measure its benefit.

Thanks,
Rakib
>
>
>

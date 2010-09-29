Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0I2MAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0I2MAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:00:22 -0400
Message-ID: <4CA32A53.6000007@redhat.com>
Date: Wed, 29 Sep 2010 14:00:19 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Matthew Wilcox <matthew@wil.cx>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: fix numbering in /proc/locks
References: <4CA0B4A5.1090701@redhat.com> <4CA0B743.2050801@parallels.com> <4CA32626.8040700@redhat.com> <4CA32677.2020203@parallels.com> <4CA3288F.4030200@redhat.com> <4CA32982.1090809@parallels.com>
In-Reply-To: <4CA32982.1090809@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2010 01:56 PM, Pavel Emelyanov wrote:
> On 09/29/2010 03:52 PM, Jerome Marchand wrote:
>> On 09/29/2010 01:43 PM, Pavel Emelyanov wrote:
>>>> Good point. My implementation is definitely wrong. But I'm afraid that
>>>> moving the increment in locks_next() won't help either. It will fail when
>>>> a program do something more than just read the file sequentially (use
>>>> of lseek() for instance). We need a better way to keep track of the
>>>> current position in the list.
>>>
>>> The seq files core implementation knows about the lseek and
>>> calls the seq_ops callbacks properly.
>>>
>>
>> Yes, but if read a few lines and then lseek() back. I'm afraid it will call
>> a few more locks_next() function and thus increase the counter again.
> 
> No. If you lseek back it calls the locks_start which should reset the
> counter, and then will call locks_next.
> 
> Can you try out my proposal and check whether it really works as expected?
> 

OK. I didn't understand you meant to keep the reset in locks_start(). I'll
try that.

Jerome

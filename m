Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2EAXE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:04:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52404 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2EAXE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:04:56 -0400
Message-ID: <4FA06C15.7000500@gmail.com>
Date: Tue, 01 May 2012 19:04:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Doug Ledford <dledford@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, sfr@canb.auug.org.au
Subject: Re: [Patch 3/4] ipc/mqueue: strengthen checks on mqueue creation
References: <1335894655-11398-1-git-send-email-dledford@redhat.com> <d280fa846e9093a3cc82d9e75da4bb8074c7d4c7.1335894230.git.dledford@redhat.com> <4FA04131.2040004@gmail.com> <4FA04373.6090100@redhat.com> <CAHGf_=p34t2jrqr1V_TP0UiXLE8g1p6UXOV25SwWC8C9h2BVBQ@mail.gmail.com> <4FA06BA2.7020703@redhat.com>
In-Reply-To: <4FA06BA2.7020703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/1/12 7:02 PM), Doug Ledford wrote:
> On 5/1/2012 4:18 PM, KOSAKI Motohiro wrote:
>>>> But ENOMEM is more inaccurate. It almostly is used for kmalloc failure.
>>>
>>> I chose ENOMEM for that particular error because above there we have
>>> checked the passed in arguments to make sure that they don't violate our
>>> allowances for max message or max message size.  If we violate either of
>>> those items, we return EINVAL.  In this case, neither of the values is
>>> invalid, it's just that together they make an overly large allocation.
>>> I would see that as more helpful to a programmer than EINVAL when the
>>> values are within the maximums allowed.  At least with ENOMEM the
>>> programmer knows they have to reduce their combined message size and
>>> message count in order to get things working.
>>
>> Incorrect. When ENOMEM is returned, programmers can't know
>> which problem was happen 1) kernel has real memory starvation
>> or 2) queue limitation exceed was happen. The problem is, you
>> introduced new overloaded error code for avoiding overload error code.
>> It doesn't make sense. My question was, why can't you choose no
>> overload error code if you want accurate one?
>
> OK, then would EOVERFLOW suit things better?

I have no seen to any confusion source this. thank you.

then, ack all of this series.
  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


>
> All this reminds me that when this is taken into Linus' kernel, we need
> to coordinate a man page update for the mq subsystem.



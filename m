Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2FRMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:25:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51459 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2FRMZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXgBYYiVU2jY+4eLngR5TdOP34J45_TpdpiZ6cFYENo3hw@mail.gmail.com>
References: <CAJd=RBB1s-_VOtoDsBbLidS51HwW6e98p=U-4mL-spByUMvETw@mail.gmail.com>
	<CA+i8gKKQyGBc-BNBJ72S6rq7aiFqS=onqWQyeY4P+VVvFCeXJw@mail.gmail.com>
	<CAJd=RBA=mvMGQgdKgW26dgd8nK2-_dW_epQLwbjOo2Zx2gsbeg@mail.gmail.com>
	<CA+i8gK+H-hm9bjJub4siH0pCdOrzRxJXaX2QjosnKCjeWYPt4A@mail.gmail.com>
	<CAJd=RBBxnD7JirPpy-jTgE9kpnZXN6gkTMsgcG8=goZxgQfTaQ@mail.gmail.com>
	<CA+i8gKLrd4JUf5P=zkj4x_yYc-kk2kjA-0To9e7iRNbZcCpLxA@mail.gmail.com>
	<CAJd=RBCa_JfHO-=HiGqz_13CaHj5KGE5-EYAYT3jd+FPofqybw@mail.gmail.com>
	<CAJd=RBC7r+a8Q6XvQX5-=0h2d5==tOjyG1HY_1q6=gfBwbWtFw@mail.gmail.com>
	<CA+i8gKKDdsG95GFkPskH1fZHBw8oMGu+4DW84Xq1-mLzzgFbrQ@mail.gmail.com>
	<CAJd=RBD2Ss1vfugZcZzA5CzRPapBJsmx7tAxijBmOgQ9tjC7cw@mail.gmail.com>
	<CANQmPXgBYYiVU2jY+4eLngR5TdOP34J45_TpdpiZ6cFYENo3hw@mail.gmail.com>
Date: Mon, 18 Jun 2012 20:25:25 +0800
Message-ID: <CAJd=RBD0-6rBkRedYfuuYRv=qbTFvbLw5vZ8YmujS0yQ+z3cAw@mail.gmail.com>
Subject: Re: [patch] BFS 420: a tiny step forward
From: Hillf Danton <dhillf@gmail.com>
To: Chen <hi3766691@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Manuel Krause <manuelkrause@t-online.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 10:04 PM, Chen <hi3766691@gmail.com> wrote:
> Are you interested in BFS-O(1), Hilff? You can take this work off and
>
No, certainly:)

> BFS-421 will completely become your own version of BFS.:-)
>
I am not short of any scheduler currently, you see, I am hammering one.

> http://rifs-scheduler.googlecode.com/files/bfso1-3.3-420.1.patch
> You just need to remove line 3084-3086 if you want to take this.
>
I have no stable access to googlecode due to reasons my local
ISP is never willing to explain, so feel free to post it on LKML
in plain text.

Thanks and Regards
Hillf

> This algorithm has been proven that it is 100% work.
>
>
> On Sun, Jun 17, 2012 at 8:32 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> On Sun, Jun 17, 2012 at 6:46 PM, Emmanuel Benisty <benisty.e@gmail.com>
>> wrote:
>>> Hi Hillf,
>>>
>>> On Thu, Jun 7, 2012 at 8:05 PM, Hillf Danton <dhillf@gmail.com> wrote:
>>>> On Thu, Jun 7, 2012 at 8:37 PM, Hillf Danton <dhillf@gmail.com> wrote:
>>>>> Hi Emmanuel
>>>>>
>>>>> On Wed, Jun 6, 2012 at 11:51 PM, Emmanuel Benisty <benisty.e@gmail.com>
>>>>> wrote:
>>>>>>
>>>>>> Unfortunately, the issue is still there.
>>>>>>
>>>>> Hang at same place?
>>>>>
>>>> And try to revert handling CPU_ONLINE, please.
>>>>
>>>>
>>>> --- a/kernel/sched/bfs.c        Sat Jun  2 17:30:28 2012
>>>> +++ b/kernel/sched/bfs.c        Thu Jun  7 20:58:36 2012
>>>> @@ -5352,7 +5352,7 @@ migration_call(struct notifier_block *nf
>>>>                /* Update our root-domain */
>>>>                grq_lock_irqsave(&flags);
>>>>                if (rq->rd) {
>>>> -                       BUG_ON(cpumask_test_cpu(cpu, rq->rd->span));
>>>> +                       BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
>>>>
>>>>                        set_rq_online(rq);
>>>>                }
>>>> --
>>>
>>> Sorry for the late reply. This patch did solve the issue, thanks.
>>>
>> Thank you, Emmanuel.
>> It is good news before 421-1 is released next week:)
>>
>>                Hillf
>> --

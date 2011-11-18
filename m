Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab1KROrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:47:02 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40815 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1KROrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:47:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAONaPpHybQL38PSq-hux5X44zuHDCQg=8L1fb+geWv00ktQq7g@mail.gmail.com>
References: <CAJd=RBC+p8033bHNfP=WQ2SU1Y1zRpj+FEi9FdjuFKkjF_=_iA@mail.gmail.com>
	<CAONaPpGQdpNDT9EuTq_xian+bRFDUsLn7AgjtG-=y0C6-9fDTQ@mail.gmail.com>
	<CAONaPpHybQL38PSq-hux5X44zuHDCQg=8L1fb+geWv00ktQq7g@mail.gmail.com>
Date: Fri, 18 Nov 2011 22:46:59 +0800
Message-ID: <CAJd=RBAxq4knDnehEXEy+yWYRwXp5ukwkNvgssKPLr+HrgUnPg@mail.gmail.com>
Subject: Re: [PATCH] hugetlb: detect race if fail to COW
From: Hillf Danton <dhillf@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <jweiner@redhat.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAIEl9ks011119

On Fri, Nov 18, 2011 at 10:21 PM, John Kacur <jkacur@redhat.com> wrote:
> On Fri, Nov 18, 2011 at 3:16 PM, John Kacur <jkacur@redhat.com> wrote:
>> On Fri, Nov 18, 2011 at 3:04 PM, Hillf Danton <dhillf@gmail.com> wrote:
>>> In the error path that we fail to allocate new huge page, before try again, we
>>> have to check race since page_table_lock is re-acquired.
>>>
>>> If racing, our job is done.
>>>
>>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>>> ---
>>>
>>> --- a/mm/hugetlb.c      Fri Nov 18 21:38:30 2011
>>> +++ b/mm/hugetlb.c      Fri Nov 18 21:48:15 2011
>>> @@ -2407,7 +2407,14 @@ retry_avoidcopy:
>>>                                BUG_ON(page_count(old_page) != 1);
>>>                                BUG_ON(huge_pte_none(pte));
>>>                                spin_lock(&mm->page_table_lock);
>>> -                               goto retry_avoidcopy;
>>> +                               ptep = huge_pte_offset(mm, address & huge_page_mask(h));
>>> +                               if (likely(pte_same(huge_ptep_get(ptep), pte)))
>>> +                                       goto retry_avoidcopy;
>>> +                               /*
>>> +                                * race occurs while re-acquiring page_table_lock, and
>>> +                                * our job is done.
>>> +                                */
>>> +                               return 0;
>>>                        }
>>>                        WARN_ON_ONCE(1);
>>>                }
>>
>>
>> I'm not sure about the veracity of the race condition, but you better
>> do spin_unlock before you return.
>>
>
> Ugh, sorry for the noise, I see that's not how it works here.

Welcome:)
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�

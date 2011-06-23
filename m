Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab1FWAm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:42:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41246 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab1FWAmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xi5Krw4FxwOZageRi5nrTaEKrmmTb+yyyEe+fHi0c5wuQJH//8MhZUr+pn0hpgvNId
         twUng8o+Sm7k8gsx4IZJ2X0jA2lkiokRnHo4gE8plJuEsXtbNSlVu6SW8VczUjXzYBEl
         NQ/ubxNhGaV3dR+quG1NMyr779z8JTr2M3Gbo=
MIME-Version: 1.0
In-Reply-To: <4E028215.90107@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
	<201106212132.39311.nai.xia@gmail.com>
	<4E01C752.10405@redhat.com>
	<4E01CC77.10607@ravellosystems.com>
	<4E01CDAD.3070202@redhat.com>
	<4E01CFD2.6000404@ravellosystems.com>
	<4E020CBC.7070604@redhat.com>
	<20110622165529.GY20843@redhat.com>
	<BANLkTinRYr9Vg==C-qyCaRmO7C_aQqBPzw@mail.gmail.com>
	<4E028215.90107@redhat.com>
Date: Thu, 23 Jun 2011 08:42:24 +0800
Message-ID: <BANLkTi=oNXAmYaC44EYnNRU2_4KFoJjubw@mail.gmail.com>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
From: Nai Xia <nai.xia@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 8:00 AM, Rik van Riel <riel@redhat.com> wrote:
> On 06/22/2011 07:37 PM, Nai Xia wrote:
>
>> On 2MB pages, I'd like to remind you and Rik that ksmd currently splits
>> huge pages before their sub pages gets really merged to stable tree.
>
> Your proposal appears to add a condition that causes ksmd to skip
> doing that, which can cause the system to start using swap instead
> of sharing memory.

Hmm, yes, no swapping. So we should make the checksum default
for huge pages, right?

>
>> So when there are many 2MB pages each having a 4kB subpage
>> changed for all time, this is already a concern for ksmd to judge
>> if it's worthwhile to split 2MB page and get its sub-pages merged.
>> I think the policy for ksmd in a system should be "If you cannot do sth
>> good,
>> at least do nothing evil". So I really don't think we can satisfy _all_
>> people.
>> Get a general method and give users one or two knobs to tune it when they
>> are the corner cases. How do  you think of my proposal ?
>
> I think your proposal makes sense for 4kB pages, but the ksmd
> policy for 2MB pages probably needs to be much more aggressive.

I now agree with you on the whole point. Let's fall back to checksum
Thanks for make my mind clear! :)

And shall we provide a interface to users if he _really_ what to judge the dirty
bit from the pmd level? I think we should agree to one point before I
misunderstand
you and spam you with my next submission :P


And thanks for your time viewing!

-Nai


>
> --
> All rights reversed
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496Ab1FWAOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:14:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38635 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab1FWAO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N9i0ReFqNmVeK+PsQ00kVEAC2D2xhaZJRXalT4WBHQhBaZnYLJcdtq5D0/mNUO1tTW
         EKquYkeXyVhIRimLl2zGbhi9xlmNQXztRRsh4aMFkQ38lrZT6jKI+yR/yu9mkRGaGHOB
         JVx96syerfJxTbXEd9qfvp3+S7WYxl+dOETW4=
MIME-Version: 1.0
In-Reply-To: <20110622234450.GB20843@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
	<201106212132.39311.nai.xia@gmail.com>
	<20110622150350.GX20843@redhat.com>
	<BANLkTim85ghrK9D4f19Pt5v1+HTMzVXxnw@mail.gmail.com>
	<20110622234450.GB20843@redhat.com>
Date: Thu, 23 Jun 2011 08:14:28 +0800
Message-ID: <BANLkTik2P95vxuUkRi5C+=Xaw7TkE3JR2w@mail.gmail.com>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
From: Nai Xia <nai.xia@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 7:44 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Thu, Jun 23, 2011 at 07:19:06AM +0800, Nai Xia wrote:
>> OK, I'll have a try over other workarounds.
>> I am not feeling good about need_pte_unmap myself. :-)
>
> The usual way is to check VM_HUGETLB in the caller and to call another
> function that doesn't kmap. Casting pmd_t to pte_t isn't really nice
> (but hey we're also doing that exceptionally in smaps_pte_range for
> THP, but it safe there because we're casting the value of the pmd, not
> the pointer to the pmd, so the kmap is done by the pte version of the
> caller and not done by the pmd version of the caller).
>
> Is it done for migrate? Surely it's not for swapout ;).

Thanks for the hint. :-)

You know, another thing I am worried about is that I think I
did make page_check_address()  return a pmd version for skipping the
tail subpages ...
I did detecte a schedule in atomic if I kunmap() the returned value. :-(

>
>> Thanks for viewing!
>
> You're welcome!
>
> JFYI I'll be offline on vacation for a week, starting tomorrow, so if
> I don't answer in the next few days that's the reason but I'll follow
> the progress in a week.

Have a nice vacation man! Enjoy the sunlight, we all have enough
of code in rooms. ;-)


Thanks,
Nai

>
> Thanks!
> Andrea
>

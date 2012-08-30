Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2H3G2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 02:28:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36016 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2H3G2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 02:28:37 -0400
References: <1346267046-6724-1-git-send-email-jacob.shin@amd.com> <1346267046-6724-5-git-send-email-jacob.shin@amd.com> <CAE9FiQWcYmROV1SHzk0_RUQfniDwgbyiCbcbRbXatYvYhuGp7Q@mail.gmail.com> <20120829213246.GE31869@aftab.osrc.amd.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120829213246.GE31869@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 4/6] x86: Only direct map addresses that are marked as E820_RAM
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 29 Aug 2012 23:28:16 -0700
To: Borislav Petkov <bp@amd64.org>, Yinghai Lu <yinghai@kernel.org>
CC: Jacob Shin <jacob.shin@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <2e8c14cd-b82a-49e6-8d5e-85dbe86da6ca@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This week is Kernel Summit & Plumbers... people are kind of distracted.

Borislav Petkov <bp@amd64.org> wrote:

>On Wed, Aug 29, 2012 at 02:17:51PM -0700, Yinghai Lu wrote:
>> > +struct range pfn_mapped[E820_X_MAX];
>> > +int nr_pfn_mapped;
>> 
>> change to static?
>> 
>> > +
>> > +void add_pfn_range_mapped(unsigned long start_pfn, unsigned long
>end_pfn)
>> > +{
>> > +       nr_pfn_mapped = add_range_with_merge(pfn_mapped,
>E820_X_MAX,
>> > +                                            nr_pfn_mapped,
>start_pfn, end_pfn);
>> > +       nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
>> > +
>> > +       max_pfn_mapped = max(max_pfn_mapped, end_pfn);
>> > +
>> > +       if (end_pfn <= (1UL << (32 - PAGE_SHIFT)))
>> > +               max_low_pfn_mapped = max(max_low_pfn_mapped,
>end_pfn);
>> > +}
>> > +
>> > +bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long
>end_pfn)
>> > +{
>> > +       int i;
>> > +
>> > +       for (i = 0; i < nr_pfn_mapped; i++)
>> > +               if ((start_pfn >= pfn_mapped[i].start) &&
>> > +                   (end_pfn <= pfn_mapped[i].end))
>> > +                       return true;
>> > +
>> > +       return false;
>> > +}
>> > +
>> > +bool pfn_is_mapped(unsigned long pfn)
>> > +{
>> > +       return pfn_range_is_mapped(pfn, pfn + 1);
>> > +}
>> 
>> wonder if those functions have to be in arch/x86/kernel/setup.c.
>> 
>> also do we need to update the tracking array when we have do memory
>hot-remove?
>
>Would you please make sure you've reviewed this whole patchset
>thoroughly so that Jacob can do all changes at once and not keep
>resending them twice a week.
>
>Thanks a lot!
>
>-- 
>Regards/Gruss,
>Boris.
>
>Advanced Micro Devices GmbH
>Einsteinring 24, 85609 Dornach
>GM: Alberto Bozzo
>Reg: Dornach, Landkreis Muenchen
>HRB Nr. 43632 WEEE Registernr: 129 19551

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

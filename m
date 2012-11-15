Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768559Ab2KORjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:39:32 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:57905 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768505Ab2KORja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:39:30 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.86.248]
In-Reply-To: <CALLhW=46xUZzuEBaQD7vsOTQOGR7bwXMSM_mugN_gWa-oqwfuw@mail.gmail.com>
References: <1352860489-19960-1-git-send-email-omar.luna@linaro.org>
 <1352860489-19960-3-git-send-email-omar.luna@linaro.org> <CAK=WgbZm+sjavwb_Li_W5ygm0XuS9YMYfQEkdoB188Uir0arGg@mail.gmail.com>
 <CALLhW=46xUZzuEBaQD7vsOTQOGR7bwXMSM_mugN_gWa-oqwfuw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 15 Nov 2012 19:39:08 +0200
Message-ID: <CAK=WgbaTupjayMLmgptfLtNkkk_GZL8RYQrYn8O7FG5GpANswg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ARM: OMAP3/4: iommu: adapt to runtime pm
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>,
        Russell King <linux@arm.linux.org.uk>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Omar,

On Thu, Nov 15, 2012 at 6:53 PM, Omar Ramirez Luna <omar.luna@linaro.org> wrote:
> On 14 November 2012 03:54, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> Most of the above questions imply this patch not only converts the
>> iommu to runtime PM, but may carry additional changes that may imply
>> previous implementation is sub-optimal. I hope we can clearly document
>> the motivation behind these changes too (maybe even consider
>> extracting them to a different patch ?).
>
> I didn't want to extract this changes into different patches since
> they could be included in this one, otherwise it would look like lines
> adding and then deleting runtime pm functions.
>
> I do agree description is missing, again I thought I had done this
> somewhere but looks like I didn't, will update these. If you think
> these should be different patches please let me know, otherwise I
> would like to keep a single *documented* patch.

It seems like there are 3 different logical changes here:

1. remove clk_* invocations from iommu_fault_handler()
2. keep clocks enabled as long as iommu is enabled
3. convert to runtime pm

If we split this to three patches in this order, you won't have to add
and remove runtime pm functions.

Let's do it, please. It's a small nuisance now, but may be really
helpful in the future when someone tries to debug stuff and understand
the motivation behind these changes. It'd make it much easier for you
to document the changes, too: you have an entire commit log per
change.

Thanks,
Ohad.

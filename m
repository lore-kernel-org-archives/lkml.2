Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab0GSJVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 05:21:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64827 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760266Ab0GSJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 05:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jTuOgTMbrt0LEHk73EUUrRh0C5/L5p8yAVzK0Mrcsbrt3kt7xKZdXFmX1RX/IlfeFE
         rwbbZ9PKCW+wlffXyE5FJZuwhVmzT1Jp8S7HwDiEq0/3TFjVy5715/KIUWzfAooQyEpZ
         oSxQq7jXOOtU9RT5DbVZQml5DPAxX4/Z/r6DQ=
MIME-Version: 1.0
In-Reply-To: <20100717000108.GB21293@labbmf-linux.quicinc.com>
References: <4C3C0032.5020702@codeaurora.org>
	<20100713150311B.fujita.tomonori@lab.ntt.co.jp>
	<20100713121420.GB4263@codeaurora.org>
	<20100714104353B.fujita.tomonori@lab.ntt.co.jp>
	<20100714201149.GA14008@codeaurora.org>
	<20100714220536.GE18138@n2100.arm.linux.org.uk>
	<20100715012958.GB2239@codeaurora.org>
	<20100715085535.GC26212@n2100.arm.linux.org.uk>
	<AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com>
	<20100716075856.GC16124@n2100.arm.linux.org.uk>
	<20100717000108.GB21293@labbmf-linux.quicinc.com>
Date: Mon, 19 Jul 2010 05:21:35 -0400
Message-ID: <AANLkTinTQXbsD91JDHiSFrvDoUeHbaGUGSWA-5aT5ZCr@mail.gmail.com>
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device 
	memory management
From: Tim HRM <zt.tmzt@gmail.com>
To: Larry Bassel <lbassel@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, ebiederm@xmission.com,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 8:01 PM, Larry Bassel <lbassel@codeaurora.org> wrote:
> On 16 Jul 10 08:58, Russell King - ARM Linux wrote:
>> On Thu, Jul 15, 2010 at 08:48:36PM -0400, Tim HRM wrote:
>> > Interesting, since I seem to remember the MSM devices mostly conduct
>> > IO through regions of normal RAM, largely accomplished through
>> > ioremap() calls.
>> >
>> > Without more public domain documentation of the MSM chips and AMSS
>> > interfaces I wouldn't know how to avoid this, but I can imagine it
>> > creates a bit of urgency for Qualcomm developers as they attempt to
>> > upstream support for this most interesting SoC.
>>
>> As the patch has been out for RFC since early April on the linux-arm-kernel
>> mailing list (Subject: [RFC] Prohibit ioremap() on kernel managed RAM),
>> and no comments have come back from Qualcomm folk.
>
> We are investigating the impact of this change on us, and I
> will send out more detailed comments next week.
>
>>
>> The restriction on creation of multiple V:P mappings with differing
>> attributes is also fairly hard to miss in the ARM architecture
>> specification when reading the sections about caches.
>>
>
> Larry Bassel
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>

Hi Larry and Qualcomm people.
I'm curious what your reason for introducing this new api (or adding
to dma) is.  Specifically how this would be used to make the memory
mapping of the MSM chip dynamic in contrast to the fixed _PHYS defines
in the Android and Codeaurora trees.

I'm also interested in how this ability to map memory regions as files
for devices like KGSL/DRI or PMEM might work and why this is better
suited to that purpose than existing methods, where this fits into
camera preview and other issues that have been dealt with in these
trees in novel ways (from my perspective).

Thanks,
Timothy Meade
tmzt #htc-linux

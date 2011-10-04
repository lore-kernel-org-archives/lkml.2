Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab1JDSQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:16:08 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42575 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932853Ab1JDSQG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:16:06 -0400
From: Kevin Hilman <khilman@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 2/5] ARM: OMAP: omap_device: add a method to set iommu private archdata
Organization: Texas Instruments, Inc.
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
	<1316948337-7924-3-git-send-email-ohad@wizery.com>
	<87sjni9aql.fsf@ti.com>
	<CAK=WgbZhz8LcAYZEY3qqRkX4E_wtspWp09Eq9G=5VdpoMMF1FQ@mail.gmail.com>
Date: Tue, 04 Oct 2011 11:15:59 -0700
In-Reply-To: <CAK=WgbZhz8LcAYZEY3qqRkX4E_wtspWp09Eq9G=5VdpoMMF1FQ@mail.gmail.com>
	(Ohad Ben-Cohen's message of "Tue, 27 Sep 2011 21:09:57 +0300")
Message-ID: <87botwk4gw.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen <ohad@wizery.com> writes:

> Hi Kevin,
>
> On Tue, Sep 27, 2011 at 1:53 AM, Kevin Hilman <khilman@ti.com> wrote:
>> Benoit did just this in preparation for DT.
>>
>>       http://marc.info/?l=linux-omap&m=131672480111927&w=2
>>
>> Will that meet your needs?
>
> It's almost there, but not entirely.
>
> Benoit's alloc/delete functions focus on the omap_device part, leaving
> the handling of the platform device (allocation and pdata setting) to
> omap_device_build_ss(), which at the same time registers the pdev.
>
> I'd need to split omap_device_build_ss() into two: an alloc() part
> which does everything but registering the pdev, and a register() part.
> Users will first call alloc(), manually set archdata members, and then
> call the register() part.
>
> Something like this (compile-tested only, based on Benoit's
> for_3.2/4_omap4_dt_early_devices branch):

[...]

> That's the idea; please tell me how you'd like to see this go forward
> (there are at least several personal-taste issues here, e.g., naming:
> now we have two sets of alloc/delete functions which have different
> semantics) 

The approach is OK with me, but I'm a bit torn about whether or not to
merge this since the need for this should go away when converting to DT.
Is anyone working on IOMMU DT description?

I guess if I do merge this, we can also clean this up significantly
after all devices are converted to DT.

> and which branch would you like me to base this work off of
> (not sure if Benoit's patches already went into your
> for_3.2/omap_device branch) and I'll respin this patch properly.

Unless it has other dependencies on Benoit's further DT patches, you can
base this on my for_3.2/omap_device-2 branch which includes Benoit's
alloc changes.

Kevin

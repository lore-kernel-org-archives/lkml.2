Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947122Ab2LFTpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:45:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45758 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947077Ab2LFTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:45:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAK=WgbYF1RWoH-QxOAuO89h3P1BE84Oqs2fsUXF5eLDPPuLsAA@mail.gmail.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
	<1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
	<CAJK669adq29ipOCTOyXNoqW=gF4pOJZZgZ_0tnjm75JY22Gvag@mail.gmail.com>
	<CAK=WgbbK+p3BGcohzgoY9Y57xD1kYHyGDu-FXFXaLFoA9xz7ow@mail.gmail.com>
	<CAJK669bpog-nNCZ5F5dGWqrS8p5ibob_5eq51r8+6NNimYgpGQ@mail.gmail.com>
	<CAK=WgbYxr66xUA0SsGO5b5PowRpH+mHeOSOuW+6V_S90tu=Ntg@mail.gmail.com>
	<CAK=WgbYF1RWoH-QxOAuO89h3P1BE84Oqs2fsUXF5eLDPPuLsAA@mail.gmail.com>
Date: Thu, 6 Dec 2012 20:45:31 +0100
Message-ID: <CAJK669ZcH-GTrkCZRMjDnr2pBjODifCHcSXCvceFPQtqZyZftg@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Bhavin Shah <bshah@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Sat, Aug 11, 2012 at 2:34 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Fri, Aug 10, 2012 at 6:30 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> This will solve all sort of open issues we have (or going to have soon):
>>
...
> 1. dynamically-allocated address of the vrings can be communicated
> 2. vdev statuses can be communicated
> 3. virtio config space will finally become bi-directional as it should

I just posted a RFC patch-set on this to linux-kernel@vger.kernel.org.
Review comments is welcomed :-)

> and 5. let the remote processor know about the notifyids that we've
> dynamically allocated.

I have run into one issue with the dynamically allocated notifyids. When
allocating multiple virtio devices, only ids for the first virtio
device is allocated
when the remote device is started.  This is fails for me, because I need to know
all of the kick-ids before starting the remote device.

Do you have any preference on how to solve this, Ohad?

One idea could be to call rproc->start from a work-queue and wait for completion
of firmware loading before actually starting. In this way we will not
trigger start-up
of the remote device before all virtio devices and their kick-ids are allocated.

Thanks,
Sjur

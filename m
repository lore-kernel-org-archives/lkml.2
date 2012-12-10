Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2LJSIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:08:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33360 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2LJSID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:08:03 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.115.201]
In-Reply-To: <CAJK669ZcH-GTrkCZRMjDnr2pBjODifCHcSXCvceFPQtqZyZftg@mail.gmail.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAJK669adq29ipOCTOyXNoqW=gF4pOJZZgZ_0tnjm75JY22Gvag@mail.gmail.com>
 <CAK=WgbbK+p3BGcohzgoY9Y57xD1kYHyGDu-FXFXaLFoA9xz7ow@mail.gmail.com>
 <CAJK669bpog-nNCZ5F5dGWqrS8p5ibob_5eq51r8+6NNimYgpGQ@mail.gmail.com>
 <CAK=WgbYxr66xUA0SsGO5b5PowRpH+mHeOSOuW+6V_S90tu=Ntg@mail.gmail.com>
 <CAK=WgbYF1RWoH-QxOAuO89h3P1BE84Oqs2fsUXF5eLDPPuLsAA@mail.gmail.com> <CAJK669ZcH-GTrkCZRMjDnr2pBjODifCHcSXCvceFPQtqZyZftg@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 10 Dec 2012 20:07:41 +0200
Message-ID: <CAK=WgbbK6hJF-cWr92pExRJap4K-Hij3J55qozSbFciGk1tnMw@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Bhavin Shah <bshah@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Thu, Dec 6, 2012 at 9:45 PM, Sjur Brændeland <sjurbren@gmail.com> wrote:
> I just posted a RFC patch-set on this to linux-kernel@vger.kernel.org.
> Review comments is welcomed :-)

Great, will take a look, thanks a lot!

> I have run into one issue with the dynamically allocated notifyids. When
> allocating multiple virtio devices, only ids for the first virtio
> device is allocated
> when the remote device is started.  This is fails for me, because I need to know
> all of the kick-ids before starting the remote device.
>
> Do you have any preference on how to solve this, Ohad?
>
> One idea could be to call rproc->start from a work-queue and wait for completion
> of firmware loading before actually starting. In this way we will not
> trigger start-up
> of the remote device before all virtio devices and their kick-ids are allocated.

Yes, it would work, but I'm not sure it would be very intuitive for
others to understand why we spawn a new context upon powering on the
processor.

Seems to me we may want instead to fix the problem directly by
splitting rproc_handle_vdev() to two stages, where the second stage
will only include the rproc_add_virtio_dev() part, and will be invoked
after all vdev have been processed.

Will that work for you ?

Thanks,
Ohad.

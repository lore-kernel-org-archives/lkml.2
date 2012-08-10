Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2HJPbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 11:31:01 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42705 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2HJPa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 11:30:59 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.151.238]
In-Reply-To: <CAJK669bpog-nNCZ5F5dGWqrS8p5ibob_5eq51r8+6NNimYgpGQ@mail.gmail.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAJK669adq29ipOCTOyXNoqW=gF4pOJZZgZ_0tnjm75JY22Gvag@mail.gmail.com>
 <CAK=WgbbK+p3BGcohzgoY9Y57xD1kYHyGDu-FXFXaLFoA9xz7ow@mail.gmail.com> <CAJK669bpog-nNCZ5F5dGWqrS8p5ibob_5eq51r8+6NNimYgpGQ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 10 Aug 2012 18:30:38 +0300
Message-ID: <CAK=WgbYxr66xUA0SsGO5b5PowRpH+mHeOSOuW+6V_S90tu=Ntg@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: linux-kernel@vger.kernel.org, Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Bhavin Shah <bshah@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Thu, Aug 9, 2012 at 11:35 PM, Sjur Brændeland <sjurbren@gmail.com> wrote:
> Any thoughts on how to go about to fix this?

The general direction I have in mind is to put the resource table in
its final location while we do the first pass of fw parsing.

This will solve all sort of open issues we have (or going to have soon):

1. dynamically-allocated address of the vrings can be communicated
2. vdev statuses can be communicated
3. virtio config space will finally become bi-directional as it should
4. dynamically probed rproc-to-rproc IPC could then take place

It's the real deal :)

The only problem with this approach is that the resource table isn't
reloaded throughout cycles of power up/down, and that is insecure.
We'll have to manually reload it somewhere after the rproc is powered
down (or before it is powered up again).

This change will break existing firmwares, but it looks required and inevitable.

Thanks,
Ohad.

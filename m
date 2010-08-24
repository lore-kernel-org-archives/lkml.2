Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0HXVRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:17:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34125 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab0HXVRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QEM2KS1lPmkYdGtvq93hzcO0LbQ9YTe4ZE+orAZKNWOMM+1YoXO9KhfKLar4zpd7dM
         Dmo8VCmZVEXT4AyNHq3elq40ZY7pTqp8JAGENqiBDeV/8JB9OIttfHhFxI8nP+8waHLT
         W/bP5Pke5+XWZBhOIe/xnbfc93J1mVDsjvfNs=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F0FA39BA@dlee06.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
	<1277943660-4112-2-git-send-email-x0095840@ti.com>
	<1277943660-4112-3-git-send-email-x0095840@ti.com>
	<1277943660-4112-4-git-send-email-x0095840@ti.com>
	<1277943660-4112-5-git-send-email-x0095840@ti.com>
	<1277943660-4112-6-git-send-email-x0095840@ti.com>
	<1277943660-4112-7-git-send-email-x0095840@ti.com>
	<1277943660-4112-8-git-send-email-x0095840@ti.com>
	<1277943660-4112-9-git-send-email-x0095840@ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD34D5@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3ADE@dlee06.ent.ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD39F6@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3BB2@dlee06.ent.ti.com>
	<AANLkTimENxUjUWJQSZ1dmdkX_9hQ0pjat-kyR9oNjVxf@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3883@dlee06.ent.ti.com>
	<AANLkTi=NuPu6bvv6KF7sXRp02bvfz7oRkG1SG1PstA-H@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA397F@dlee06.ent.ti.com>
	<AANLkTinaJ=xn_CAJznVtMcA0nwK_-gbo05OQKM7PuoYA@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3995@dlee06.ent.ti.com>
	<AANLkTinjMujus-28DcLzZ+16GAGpLohwhPhuTi5uKhB8@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA39BA@dlee06.ent.ti.com>
Date: Wed, 25 Aug 2010 00:17:50 +0300
Message-ID: <AANLkTikQCTtwOkAmt3PZrOkxi=VzJtfNKGsH=YXawt9t@mail.gmail.com>
Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 10:30 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>> Oh, I actually meant the DMM pool.
>>
>> a) 1. Migrate to iommu, 2. Remove DMM completely
>> b) 1. Remove DMM pool, 2. Migrate to iommu 3. Remove DMM completely
>
> Ok, what is the issue with DMM pool?

>From what I've heard; fragmentation.

> The issue I see removing DMM pool in this moment and making all the DMM
> Available (from 0x11000000 to 0xFFFFFFFF omap3 case) that is:
>
> The DMM module allocates a list of "struct map_page" elements base on
> DMM_POOL_SIZE to keep track of memory reserved and mapped.
>
> Memory allocated = DMM_POOL_SIZE / PAGE_SIZE * sizeof(struct map_page);
>
> So making all memory avalible it will increase the memory used for DMM
> Module and it could be quite significant.
>
> Iovmm.c module, the list is increased dynamically when it is needed so
> It does no have that problem. Then when the migration is done and
> Iovmm.c module is used the DMM_POOL_SIZE can be removed without issues.

It seems that this "memory allocated" you are taking about is an
array, but what we would like is a list, like apparently iovmm is
using. I think I can give that a try if needed.

However, from what I can see iovmm can be used instead of dmm even if
the switch to iommu is not yet there.

-- 
Felipe Contreras

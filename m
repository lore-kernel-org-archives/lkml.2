Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2LJKYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:24:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7171 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab2LJKYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:24:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 10 Dec 2012 02:23:11 -0800
Message-ID: <50C5B948.5090203@nvidia.com>
Date: Mon, 10 Dec 2012 12:28:24 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC,v2,1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <50B72696.3030205@gmail.com>
In-Reply-To: <50B72696.3030205@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 11:10, Mark Zhang wrote:
>> +
>> +/**
>> + * Write a cpu syncpoint increment to the hardware, without touching
>> + * the cache. Caller is responsible for host being powered.
>> + */
>> +static void host1x_syncpt_cpu_incr(struct nvhost_syncpt *sp, u32 id)
>> +{
>> +     struct nvhost_master *dev = syncpt_to_dev(sp);
>> +     u32 reg_offset = id / 32;
>> +
>> +     if (!nvhost_module_powered(dev->dev)) {
>> +             dev_err(&syncpt_to_dev(sp)->dev->dev,
>> +                     "Trying to access host1x when it's off");
>> +             return;
>> +     }
>> +
>> +     if (!nvhost_syncpt_client_managed(sp, id)
>> +                     && nvhost_syncpt_min_eq_max(sp, id)) {
>> +             dev_err(&syncpt_to_dev(sp)->dev->dev,
>> +                     "Trying to increment syncpoint id %d beyond max\n",
>> +                     id);
>> +             return;
>> +     }
>> +     writel(BIT_MASK(id), dev->sync_aperture +
>> +                     host1x_sync_syncpt_cpu_incr_r() + reg_offset * 4);
> 
> I have a stupid question: According to the name and the context of this
> function, seems it increases the syncpt value which specified by param
> "id". So how does this "writel" increase the value? I don't know much
> about host1x/syncpt reg operations, so could you explain a little bit or
> I just completely have a wrong understanding?

I believe I've implemented most of the requests in this mail, but I seem
to have missed answering this question.

writel() to that register invokes a method in host1x, which increments
the sync point indicated by the value of the register by one.

Best regards,
Terje

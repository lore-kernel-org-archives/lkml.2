Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0LBCKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:10:04 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56367 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755585Ab0LBCKB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:10:01 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=q1HzYBpMH_pP+S5BtBQpHs62+zNfd_MtWHFuu@mail.gmail.com>
References: <1291147139-23472-1-git-send-email-davidsin@ti.com>
	<1291147139-23472-2-git-send-email-davidsin@ti.com>
	<AANLkTi=q1HzYBpMH_pP+S5BtBQpHs62+zNfd_MtWHFuu@mail.gmail.com>
Date: Wed, 1 Dec 2010 20:10:00 -0600
Message-ID: <AANLkTi=YUYuxQE8pDZrN5-PJq1Q3jw7cP2yZKCXNAvPP@mail.gmail.com>
Subject: Re: [RFC v2 1/8] TILER-DMM: DMM-PAT driver for TI TILER
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: "Varadarajan, Charulatha" <charu@ti.com>
Cc: David Sin <davidsin@ti.com>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lajos Molnar <molnar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 12:04 AM, Varadarajan, Charulatha <charu@ti.com> wrote:
> David,

>
>> +               if (!oh)
>> +                       goto error;
>> +
>> +               data->base = oh->_mpu_rt_va;
>
> not required. Make use of platform_get APIs in probe to extract the
> base, dma and irq info using pdev.

Not sure about using platform_get APIs. I think one has to use
omap_hwmod_get_mpu_rt_va to get the address, which internally returns
oh-<_mpu_rt_va.
omap_hwmod_get_mpu_rt_va was added so that the individual drivers can
avoid doing the ioremap.
check the discussion regarding this.
http://www.spinics.net/lists/linux-omap/msg33048.html


Thank you,
Best regards,
Hari Kanigeri

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1IVGiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:38:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1IVGiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4x-SxYLyuyR9nQ530DhmfYN-Bqc2DOSyAVhM=h3zxCvMw@mail.gmail.com>
References: <1316166200-20595-1-git-send-email-Baohua.Song@csr.com>
	<CABb+yY2L=wfRoascoriAcnNMKkV7LbQEHCpp78+rCY=aM46x7A@mail.gmail.com>
	<CAGsJ_4zURv1_zJ0rwZawa8VSOw0kT9U4-cCCj2Q4-BhV1pdTHA@mail.gmail.com>
	<CABb+yY3T7JmcLXY-6GYHqF+3SiVK5N0xGzqsE8pv8A+S10hWQw@mail.gmail.com>
	<CABb+yY3mCHwWx-8gQG75107eWQBT1kPDu59vi9vHU+OQFXq_kg@mail.gmail.com>
	<CAGsJ_4x-SxYLyuyR9nQ530DhmfYN-Bqc2DOSyAVhM=h3zxCvMw@mail.gmail.com>
Date: Thu, 22 Sep 2011 12:08:19 +0530
Message-ID: <CABb+yY3ufFhD6Gf-OqYPpa2k--c8z52fFn6VDEpmc_NgWC04XQ@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: delete redundant chan_id and chancnt
 initialization in dma drivers
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <Baohua.Song@csr.com>, Piotr Ziecik <kosmo@semihalf.com>,
        Vinod Koul <vinod.koul@intel.com>, Pelagicore AB <info@pelagicore.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Yong Wang <yong.y.wang@intel.com>, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 12:01 PM, Barry Song <21cnbao@gmail.com> wrote:
> 2011/9/22 Jassi Brar <jassisinghbrar@gmail.com>:
>> On Thu, Sep 22, 2011 at 11:11 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>>>
>>>> client drivers can request a specific chan_id just like it can request a gpio.
>>> No dear. That's not gonna fly if we are to have common client drivers
>>> across SoCs.
>>>
>> Btw, I meant you can't simply have clients specify a channel number and
>> get the channel in a portable manner. Clients need to specify the capabilities
>> they need of the channel.
>
> if the dmac is flexible in design, what you said is right. but the
> problem is that there are some chips which actually fix one channel to
> one peripheral.
Nevertheless it is better to assume the dmac's req-signals could be hacked
to re-route at even runtime.
Also it won't work for client drivers that run the same controller on different
SoC with a different dmac.

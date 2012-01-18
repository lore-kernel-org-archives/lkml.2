Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2ARMYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab2ARMYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:24:07 -0500
Message-ID: <4F16B9D7.2030104@redhat.com>
Date: Wed, 18 Jan 2012 10:23:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "Semwal, Sumit" <sumit.semwal@ti.com>, Robert Morell <rmorell@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, sumit.semwal@linaro.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie> <1326845297-6233-2-git-send-email-rmorell@nvidia.com> <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com> <201201181214.12055.arnd@arndb.de>
In-Reply-To: <201201181214.12055.arnd@arndb.de>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-01-2012 10:14, Arnd Bergmann escreveu:
> On Wednesday 18 January 2012, Semwal, Sumit wrote:
>> On Wed, Jan 18, 2012 at 5:38 AM, Robert Morell <rmorell@nvidia.com> wrote:
>>> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
>>> issue, and not really an interface".  The dma-buf infrastructure is
>>> explicitly intended as an interface between modules/drivers, so it
>>> should use EXPORT_SYMBOL instead.
>>
>> + Konrad, Arnd, Mauro: there were strong objections on using
>> EXPORT_SYMBOL in place of EXPORT_SYMBOL_GPL by all 3 of them; I
>> suggest we first arrive at a consensus before merging this patch.
> 
> We discussed this before. The reason for using EXPORT_SYMBOL_GPL here is
> that the interface is low-level and that it's meant to be used by
> subsystems that export user-level interface based on that and come
> with their own device driver interface, such as V4L or DRM.
> 
> While there is an eternal debate over whether there should or should
> not be out of tree device drivers, I think there is very little to gain
> by allowing dma_buf to be used by out of tree *subsystems*.
> Further, a device driver that tries to use the interface but sits outside
> of the regular subsystems is a bad technical choice and we should not
> encourage those either.
> 
> NAK

I fully agree with Arnd.

A bug on a driver using such low-level interface could cause side effects
at the wrong places. In order to handle such bugs, the developers and the
maintainers of both subsystems need to see the source code of the entire
pipeline, with is not possible if is there any non-GPL'd driver.

NAK

Mauro.

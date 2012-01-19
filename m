Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2ASH0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:26:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39494 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2ASH0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:26:24 -0500
MIME-Version: 1.0
In-Reply-To: <4F16B9D7.2030104@redhat.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
	<1326845297-6233-2-git-send-email-rmorell@nvidia.com>
	<CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
	<201201181214.12055.arnd@arndb.de>
	<4F16B9D7.2030104@redhat.com>
Date: Thu, 19 Jan 2012 07:26:23 +0000
Message-ID: <CAPM=9tyeqke9-SKarg8OJEyRCEtZmeGtq0_Z1+30DMjsSqqn1g@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
From: Dave Airlie <airlied@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Semwal, Sumit" <sumit.semwal@ti.com>,
        Robert Morell <rmorell@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, sumit.semwal@linaro.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:23 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 18-01-2012 10:14, Arnd Bergmann escreveu:
>> On Wednesday 18 January 2012, Semwal, Sumit wrote:
>>> On Wed, Jan 18, 2012 at 5:38 AM, Robert Morell <rmorell@nvidia.com> wrote:
>>>> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
>>>> issue, and not really an interface".  The dma-buf infrastructure is
>>>> explicitly intended as an interface between modules/drivers, so it
>>>> should use EXPORT_SYMBOL instead.
>>>
>>> + Konrad, Arnd, Mauro: there were strong objections on using
>>> EXPORT_SYMBOL in place of EXPORT_SYMBOL_GPL by all 3 of them; I
>>> suggest we first arrive at a consensus before merging this patch.
>>
>> We discussed this before. The reason for using EXPORT_SYMBOL_GPL here is
>> that the interface is low-level and that it's meant to be used by
>> subsystems that export user-level interface based on that and come
>> with their own device driver interface, such as V4L or DRM.
>>
>> While there is an eternal debate over whether there should or should
>> not be out of tree device drivers, I think there is very little to gain
>> by allowing dma_buf to be used by out of tree *subsystems*.
>> Further, a device driver that tries to use the interface but sits outside
>> of the regular subsystems is a bad technical choice and we should not
>> encourage those either.
>>
>> NAK
>
> I fully agree with Arnd.
>
> A bug on a driver using such low-level interface could cause side effects
> at the wrong places. In order to handle such bugs, the developers and the
> maintainers of both subsystems need to see the source code of the entire
> pipeline, with is not possible if is there any non-GPL'd driver.

Just as an aside you shouldn't be debugging tainted kernels anyways.

The thing is if we don't provide the interface that is known working
for this, then we end up requiring the nvidia binary to jump through
hoops which is more likely to make thing unstable.

At that point I'd start to seriously consider whether drm needs
dma-buf since one of the things I will get pressure to share buffers
with is for optimus. The pressure isn't from nvidia, but from users
and customers.

I'd like to at least remove debuggabilty from the argument, that is
why we have tainting, if you ignore taint + lsmod output then
export_symbol won't matter.

Dave.

>
> NAK
>
> Mauro.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

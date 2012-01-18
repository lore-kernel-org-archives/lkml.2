Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2ARMV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:21:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48809 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2ARMV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:21:57 -0500
MIME-Version: 1.0
In-Reply-To: <201201181214.12055.arnd@arndb.de>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
	<1326845297-6233-2-git-send-email-rmorell@nvidia.com>
	<CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
	<201201181214.12055.arnd@arndb.de>
Date: Wed, 18 Jan 2012 12:21:56 +0000
Message-ID: <CAPM=9txEgGgbim5Gtz5=Cr5Mf3NrQCx0D=0dQu25gtPTzjSM7Q@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
From: Dave Airlie <airlied@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>, Robert Morell <rmorell@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, sumit.semwal@linaro.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 18 January 2012, Semwal, Sumit wrote:
>> On Wed, Jan 18, 2012 at 5:38 AM, Robert Morell <rmorell@nvidia.com> wrote:
>> > EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
>> > issue, and not really an interface".  The dma-buf infrastructure is
>> > explicitly intended as an interface between modules/drivers, so it
>> > should use EXPORT_SYMBOL instead.
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

The problem is the x86 nvidia binary driver does sit outside of
subsystems, and I forsee wanting to share buffers with it from the
Intel driver in light of the optimus hardware. Although nouveau exists
and I'd much rather nvidia get behind that wrt the kernel stuff, I
don't forsee that happening.

>From an X.org point of view it would be useful to end-users to allow
this sort of thing, nouveau is a good solution its just not going to
beat the binary driver in a lot of ways, just not sure whether I care
enough yet.

Dave.

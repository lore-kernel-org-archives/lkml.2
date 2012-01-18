Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2ARMOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:14:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2ARMOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:14:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Date: Wed, 18 Jan 2012 12:14:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Robert Morell <rmorell@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, sumit.semwal@linaro.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie> <1326845297-6233-2-git-send-email-rmorell@nvidia.com> <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
In-Reply-To: <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201181214.12055.arnd@arndb.de>
X-Provags-ID: V02:K0:yDp0vA3YeQMqH3oStXuVDeKb1zK31WVsZ6oD6Yw3UuB
 aioa+KuFuB3sgMsKwAft6Tr/lpSVRmlO6oT+oD77QUTpYSOHQR
 AEIPpYc9sxaz/5bsZ1riDzIOufn024VekMWy0enpGLxukKFCZm
 3LDJfaY0Ew935U4H+wJDPYN60lVoONydrzagr3THaWngc2gNVn
 XAUIR4uO1n043UxIuUd74txy2CBu2eOze/lVhk8zuHaH9/IrIh
 0UbRcKHXqQCH+YN2Dzv4ExWlfab8v37I1fbPrhDhBdVIZ1Ke5/
 Dpgff1UcneIHmlgn2z2d5aU/YWEkVX1A/rQohiclfyMaqa5/4+
 fx3dpgWG+DGVrA8AUsws=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 January 2012, Semwal, Sumit wrote:
> On Wed, Jan 18, 2012 at 5:38 AM, Robert Morell <rmorell@nvidia.com> wrote:
> > EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> > issue, and not really an interface".  The dma-buf infrastructure is
> > explicitly intended as an interface between modules/drivers, so it
> > should use EXPORT_SYMBOL instead.
> 
> + Konrad, Arnd, Mauro: there were strong objections on using
> EXPORT_SYMBOL in place of EXPORT_SYMBOL_GPL by all 3 of them; I
> suggest we first arrive at a consensus before merging this patch.

We discussed this before. The reason for using EXPORT_SYMBOL_GPL here is
that the interface is low-level and that it's meant to be used by
subsystems that export user-level interface based on that and come
with their own device driver interface, such as V4L or DRM.

While there is an eternal debate over whether there should or should
not be out of tree device drivers, I think there is very little to gain
by allowing dma_buf to be used by out of tree *subsystems*.
Further, a device driver that tries to use the interface but sits outside
of the regular subsystems is a bad technical choice and we should not
encourage those either.

NAK

	Arnd

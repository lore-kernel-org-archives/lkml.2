Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab2LQDKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 22:10:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53730 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2LQDKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 22:10:34 -0500
Message-ID: <50CE8D24.3010604@igel.co.jp>
Date: Mon, 17 Dec 2012 12:10:28 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: Hideki EIRAKU <hdk@igel.co.jp>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH/WIP/RFC 02/14] shmobile-iommu: Move IPMMU driver to drivers/iommu
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp> <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1355678760-27357-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1355678760-27357-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 2012/12/17 2:25, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  arch/arm/mach-shmobile/Kconfig                     |    6 ------
>  arch/arm/mach-shmobile/Makefile                    |    3 ---
>  drivers/iommu/Kconfig                              |    6 ++++++
>  drivers/iommu/Makefile                             |    1 +
>  .../ipmmu.c => drivers/iommu/shmobile-ipmmu.c      |    0
>  5 files changed, 7 insertions(+), 9 deletions(-)
>  rename arch/arm/mach-shmobile/ipmmu.c => drivers/iommu/shmobile-ipmmu.c (100%)

I agree that arch/arm is not a good place, but I'm not completely sure
that ipmmu.c belongs in drivers/iommu.  The reason is because of the PMB
functionality provided by the IPMMU.  The PMB provides a fixed address
remapping capability that is completely unrelated to the IOMMU
functionality.  Since this remapping is done by writing the IPMMU
registers directly, instead of via a page table it doesn't really fit in
well with the IOMMU API (it also supports things like tiled/linear
address translation, which require some other method to set up).  Since
the PMB and the IOMMU functions of the IPPMU share the same register
address space, we would like to have one driver to handle the register
accesses of both of these functions.  That driver is ipmmu.c.  So if
ipmmu.c is in drivers/iommu, the entire IOMMU subsystem must be enabled
in order to use the PMB functionality.
So maybe it might be better to treat the IPMMU like a multifuction
device, with a core driver (ipmmu.c) in one location and the function
implementations in their own respective directories. Does drivers/mfd
sound like a good place for it?

Thanks,
Damian.

 --
Damian Hobson-Garcia
IGEL Co.,Ltd
http://www.igel.co.jp

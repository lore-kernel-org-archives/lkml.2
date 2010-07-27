Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0G0TFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:05:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43956 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab0G0TFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:05:03 -0400
Message-ID: <4C4F2D9C.4020303@zytor.com>
Date: Tue, 27 Jul 2010 12:03:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy@goop.org>, alex.williamson@redhat.com,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
References: <1280250002-20279-1-git-send-email-konrad.wilk@oracle.com> <1280250002-20279-10-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1280250002-20279-10-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 10:00 AM, Konrad Rzeszutek Wilk wrote:
> It is paramount that we call pci_xen_swiotlb_detect before
> pci_swiotlb_detect as both implementations use the 'swiotlb'
> and 'swiotlb_force' flags. The pci-xen_swiotlb_detect inhibits
> the swiotlb_force and swiotlb flag so that the native SWIOTLB
> implementation is not enabled when running under Xen.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Albert Herranz <albert_herranz@yahoo.es>
> Cc: Ian Campbell <Ian.Campbell@citrix.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  arch/x86/kernel/pci-dma.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 

Is there any way we can abstract this out a bit more instead of crapping
on generic code?

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


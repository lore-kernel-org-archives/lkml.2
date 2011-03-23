Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab1CWNFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:05:38 -0400
Received: from fifo99.com ([67.223.236.141]:42395 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810Ab1CWNFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:05:37 -0400
Subject: Re: [RFC] mmc: msm_sdcc: Use SPS BAM as DMA engine
From: Daniel Walker <dwalker@fifo99.com>
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1300454644-11361-2-git-send-email-subhashj@codeaurora.org>
References: <1300454644-11361-1-git-send-email-subhashj@codeaurora.org>
	 <1300454644-11361-2-git-send-email-subhashj@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 06:05:35 -0700
Message-ID: <1300885535.6117.15.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 18:54 +0530, Subhash Jadavani wrote:
> On recent MSMs, ADM (Data Mover) HW is not present
> which means existing SDCC driver can perform data
> transfer in PIO (peripheral IO) mode only.
> But PIO mode requires lot of CPU attention which
> would mean consuming extra CPU MIPS.
> 
> As a replacement on these recent MSMs, there is
> a new DMA HW engine named SPS-BAM (as part of
> Smart Peripheral System of MSM) is added for
> data movement between SDCC core and system memory.
> 
> This patch has done changes in existing MSM SDCC
> driver for using SPS-BAM as DMA engine.

1300+ lines of code might warrant more of a description .. In the
subject you say "DMA engine" but does this use drivers/dma/dmaengine.c ?

> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> ---
>  drivers/mmc/host/Kconfig        |   10 +
>  drivers/mmc/host/Makefile       |    1 +
>  drivers/mmc/host/msm_sdcc.c     |  929 +++++++++++++++++++++++++++++++++++++--
>  drivers/mmc/host/msm_sdcc.h     |   47 ++
>  drivers/mmc/host/msm_sdcc_dml.c |  303 +++++++++++++
>  drivers/mmc/host/msm_sdcc_dml.h |  120 +++++
>  6 files changed, 1374 insertions(+), 36 deletions(-)
>  create mode 100644 drivers/mmc/host/msm_sdcc_dml.c
>  create mode 100644 drivers/mmc/host/msm_sdcc_dml.h

I'd do at least two patches. One that adds msm_sdcc_dml.[ch] and one
that modifies msm_sdcc.[ch] and the Kconfig and Makefile.

Daniel


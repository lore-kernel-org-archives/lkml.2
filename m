Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab1CXHhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:37:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13310 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338Ab1CXHhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:37:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6294"; a="81552247"
From: "Subhash Jadavani" <subhashj@codeaurora.org>
To: "'Daniel Walker'" <dwalker@fifo99.com>
Cc: <cjb@laptop.org>, <linux-mmc@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <davidb@codeaurora.org>,
        <bryanh@codeaurora.org>, <linux-kernel@vger.kernel.org>
References: <1300454644-11361-1-git-send-email-subhashj@codeaurora.org>	 <1300454644-11361-2-git-send-email-subhashj@codeaurora.org> <1300885535.6117.15.camel@m0nster>
In-Reply-To: <1300885535.6117.15.camel@m0nster>
Subject: RE: [RFC] mmc: msm_sdcc: Use SPS BAM as DMA engine
Date: Thu, 24 Mar 2011 13:07:22 +0530
Message-ID: <005901cbe9f6$5263f420$f72bdc60$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcvpXF5iHmezbYM1RYyx1Ax3MOvz6QAmV1ig
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of Daniel Walker
> Sent: Wednesday, March 23, 2011 6:36 PM
> To: Subhash Jadavani
> Cc: cjb@laptop.org; linux-mmc@vger.kernel.org; linux-arm-
> msm@vger.kernel.org; davidb@codeaurora.org; bryanh@codeaurora.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [RFC] mmc: msm_sdcc: Use SPS BAM as DMA engine
> 
> On Fri, 2011-03-18 at 18:54 +0530, Subhash Jadavani wrote:
> > On recent MSMs, ADM (Data Mover) HW is not present
> > which means existing SDCC driver can perform data
> > transfer in PIO (peripheral IO) mode only.
> > But PIO mode requires lot of CPU attention which
> > would mean consuming extra CPU MIPS.
> >
> > As a replacement on these recent MSMs, there is
> > a new DMA HW engine named SPS-BAM (as part of
> > Smart Peripheral System of MSM) is added for
> > data movement between SDCC core and system memory.
> >
> > This patch has done changes in existing MSM SDCC
> > driver for using SPS-BAM as DMA engine.
> 
> 1300+ lines of code might warrant more of a description .. In the
> subject you say "DMA engine" but does this use drivers/dma/dmaengine.c
> ?
> 
> > Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> > ---
> >  drivers/mmc/host/Kconfig        |   10 +
> >  drivers/mmc/host/Makefile       |    1 +
> >  drivers/mmc/host/msm_sdcc.c     |  929
> +++++++++++++++++++++++++++++++++++++--
> >  drivers/mmc/host/msm_sdcc.h     |   47 ++
> >  drivers/mmc/host/msm_sdcc_dml.c |  303 +++++++++++++
> >  drivers/mmc/host/msm_sdcc_dml.h |  120 +++++
> >  6 files changed, 1374 insertions(+), 36 deletions(-)
> >  create mode 100644 drivers/mmc/host/msm_sdcc_dml.c
> >  create mode 100644 drivers/mmc/host/msm_sdcc_dml.h
> 
> I'd do at least two patches. One that adds msm_sdcc_dml.[ch] and one
> that modifies msm_sdcc.[ch] and the Kconfig and Makefile.

Yes, I can do that. Will make sure to separate it in 2 patches when I upload v2.

Thanks,
Subhash

> 
> Daniel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


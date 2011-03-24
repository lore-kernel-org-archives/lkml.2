Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab1CXHcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:32:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12528 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab1CXHcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:32:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6294"; a="81757591"
From: "Subhash Jadavani" <subhashj@codeaurora.org>
To: "'Daniel Walker'" <dwalker@fifo99.com>
Cc: <cjb@laptop.org>, <linux-mmc@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <davidb@codeaurora.org>,
        <bryanh@codeaurora.org>, <linux-kernel@vger.kernel.org>
References: <1300454644-11361-1-git-send-email-subhashj@codeaurora.org>	 <1300454644-11361-2-git-send-email-subhashj@codeaurora.org> <1300885535.6117.15.camel@m0nster>
In-Reply-To: <1300885535.6117.15.camel@m0nster>
Subject: RE: [RFC] mmc: msm_sdcc: Use SPS BAM as DMA engine
Date: Thu, 24 Mar 2011 13:02:31 +0530
Message-ID: <005601cbe9f5$a5088750$ef1995f0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcvpXF5iHmezbYM1RYyx1Ax3MOvz6QAmIbWA
Content-Language: en-us
x-cr-hashedpuzzle: FdcU GAOt HY7J I4IO aBgP jFeD j1vw m20F sMnj udzJ v7Gi wh2l 0N/D 06Ke 29XL 3+HR;7;YgByAHkAYQBuAGgAQABjAG8AZABlAGEAdQByAG8AcgBhAC4AbwByAGcAOwBjAGoAYgBAAGwAYQBwAHQAbwBwAC4AbwByAGcAOwBkAGEAdgBpAGQAYgBAAGMAbwBkAGUAYQB1AHIAbwByAGEALgBvAHIAZwA7AGQAdwBhAGwAawBlAHIAQABmAGkAZgBvADkAOQAuAGMAbwBtADsAbABpAG4AdQB4AC0AYQByAG0ALQBtAHMAbQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG0AbQBjAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{8F8FB730-9C8C-4B5F-A557-F5BE3D19A3C4};cwB1AGIAaABhAHMAaABqAEAAYwBvAGQAZQBhAHUAcgBvAHIAYQAuAG8AcgBnAA==;Thu, 24 Mar 2011 07:32:22 GMT;UgBFADoAIABbAFIARgBDAF0AIABtAG0AYwA6ACAAbQBzAG0AXwBzAGQAYwBjADoAIABVAHMAZQAgAFMAUABTACAAQgBBAE0AIABhAHMAIABEAE0AQQAgAGUAbgBnAGkAbgBlAA==
x-cr-puzzleid: {8F8FB730-9C8C-4B5F-A557-F5BE3D19A3C4}
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

Here "DMA engine" means we are using SPS BAM as DMA HW.
No, we are not using the "drivers/dma/dmaengine.c" because MSM SPS driver is not exporting the dma compliant APIs to client. We are using the MSM SPS driver's exported APIs directly from our driver. Not sure what extra description we can put it in commit text. Any suggestion?

This is where MSM SPS driver patch is available: https://patchwork.kernel.org/patch/586271/


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
> 
> Daniel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


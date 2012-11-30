Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2K3LH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:07:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab2K3LHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:07:30 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b4-50b89370f3f3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 00/20] DMA: DMA unmap fixes
Date: Fri, 30 Nov 2012 11:57:38 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        =?iso-8859-1?q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Ira Snyder <iws@ovro.caltech.edu>,
        "Koul, Vinod" <vinod.koul@intel.com>, vipin.kumar@st.com,
        t.figa@samsung.com,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        Dave Jiang <dave.jiang@gmail.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
 <CAA9_cmfkDkF7tEmVTfD_vxtMhoTwxfFPnxtOEPT_xwsNgT1=8g@mail.gmail.com>
In-reply-to: <CAA9_cmfkDkF7tEmVTfD_vxtMhoTwxfFPnxtOEPT_xwsNgT1=8g@mail.gmail.com>
MIME-version: 1.0
Message-id: <201211301157.38802.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jQd2CyTsCDK7PU7W4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZW5fvYyz4xFUxo3sHYwPjIY4uRk4OCQETib/bnjJC2GISF+6t
	Z+ti5OIQEpjOKLF100l2CGcpk8SpC1PYQarYBKwkJravAusQEZCTWH17CjOILSygL/H/Tj+Y
	zSKgKjGj6RkriC0q4CDROXUC2FRmgV9MEvc3XGWEmNrHKPHxWScbSBWnQLDEhvc/wbp5BQQl
	fky+xwJhW0rMODIZbDOzgJZE85tNjBC2vMTmNW+ZJzAKzELSMgtJ2SwkZQsYmVcxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBIfhM6kdjCsbLA4xCnAwKvHwbtiwPUCINbGsuDL3EKMEB7OS
	CO8+wR0BQrwpiZVVqUX58UWlOanFhxilOViUxHmbPVIChATSE0tSs1NTC1KLYLJMHJxSDYxT
	tQrXyX/Ufy8u45bfv6Ep+4P8zWtegaqlEi9OTe6Y8UskpcNqnujkaWulbnfvP7vztonZUtXH
	jsvjW9ZK3rGovmkisHDS3OrCNLmFXk+YuPZy/F3/vfB62w7F/iq2YOvZF3qO5/zaF/CQw2vv
	gWPSdye6yt76rOEaL1i0bOeXbzcr5toJmGgpsRRnJBpqMRcVJwIAncqgiD8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012 21:40:57 Dan Williams wrote:
> On Mon, Nov 5, 2012 at 2:00 AM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > Hi,
> >
> > Currently DMA subsystem does DMA mapping in the core code and DMA
> > unmapping is done by device drivers.  This is counterintuitive,
> > causes code duplication and subtle errors (some drivers like PL330
> > one don't implement DMA unmapping code).  The following patchset
> > modifies DMA subsystem to do DMA unmapping in the core code.
> > It results in simpler code, less code duplication (more than 400
> > LOC is gone) and fixes the issue with missing DMA unmapping code
> > in some drivers.  Additionally many cases when DMA wasn't unmapped
> > on a failure are also fixed.
> >
> >
> > patches #1-3 add missing DMA unmap on failure to async_tx core
> > code (async_memcpy()), ioat and fsmc_nand drivers
> >
> > patch #4 fixes DMA flags used by carma-fpga driver
> 
> Ack patches 1-4

[...]

> > patch #8 adds missing DMA unmap on failure to ioat3 driver
> >
> > patch #9 fixes build for async_memset.c
> >
> > patch #10 adds missing DMA unmap on failure to async tx core
> > code (async_memset())
> 
> Ack patches 8-10

Thank you.

Could these patches be merged for 3.8 by either your's or Vinod's tree?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center

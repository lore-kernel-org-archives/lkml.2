Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1FURpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:45:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:41308 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977Ab1FURpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:45:41 -0400
Date: Wed, 22 Jun 2011 02:44:47 +0900
To: matthew@wil.cx
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        vinod.koul@intel.com, gregkh@suse.de, fujita.tomonori@lab.ntt.co.jp,
        dan.j.williams@intel.com, cjb@laptop.org, per.forlin@linaro.org
Subject: Re: [PATCH v3 RESEND] dma-mapping: add new API for
	max_segment_number
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110617124035.GA19693@parisc-linux.org>
References: <BANLkTi=-t9HVc6U6QY07su+c3WztsGoq3Q@mail.gmail.com>
	<1308227453-2034-1-git-send-email-shawn.guo@linaro.org>
	<20110617124035.GA19693@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110622023929W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 22 Jun 2011 02:44:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 06:40:35 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Jun 16, 2011 at 08:30:53PM +0800, Shawn Guo wrote:
> > Here is the user story that tells the need of the new api.  The
> > mxs-mmc is the mmc host controller for Freescale MXS architecture.
> > There are a pair of  mmc host specific parameters max_seg_size and
> > max_segs that mxs-mmc host driver needs to tell mmc core, so that
> > mmc core can know how big each data segment could be and how many
> > segments could be handled one time in a scatter list by host driver.
> > 
> > The mxs-mmc driver is one user of dmaengine mxs-dma, and it will call
> > mxs-dma to transfer data in scatter list.  That is to say mxs-mmc has
> > no idea of what max_seg_size and max_segs should be, because they are
> > all mxs-dma capability parameters, and mxs-mmc needs to query them
> > from mxs-dma.
> 
> This approach would make sense if mxs-mmc were generic, but it's tied to
> mxs-dma, so it can just as well call mxs-dma to find out how many segments
> it supports.

SCSI HBA drivers stores the max number of sg entries in
host->sg_tablesize (and scsi-ml tells the block layer about the
limit)? So if we have the generic API to handle the value, scsi HBA
drivers (and scsi-ml) could use it too?

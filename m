Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1FHHLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:11:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:56429 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1FHHLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:11:32 -0400
Date: Wed, 8 Jun 2011 16:10:58 +0900
To: dan.j.williams@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, shawn.guo@linaro.org,
        linux@arm.linux.org.uk, patches@linaro.org, vinod.koul@intel.com,
        gregkh@suse.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] dmaengine: add new dma API for
 max_segment_number
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <BANLkTi=FcNncT_6HpvB_6OnQ94f0_sz7Gw@mail.gmail.com>
References: <BANLkTin7mqqTsosPHbztaPfL7s_TUGT1qg@mail.gmail.com>
	<20110608142121T.fujita.tomonori@lab.ntt.co.jp>
	<BANLkTi=FcNncT_6HpvB_6OnQ94f0_sz7Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110608160844E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 08 Jun 2011 16:11:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011 23:56:21 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> > The dma parameter restriction could be due to software (HBA drivers,
> > or subsystem). The value should be whatever the dma device driver says
> > it is in such case?
> 
> I'm assuming that the dma driver is taking responsibility for setting
> this correctly.  How would this work otherwise... HBA driver or
> subsystem queries the dmaengine device and then sets this parameter on
> its behalf?  In other words dmanengine *is* the subsystem, if I am
> understanding your definition.

Oops, I meant that the subsystem is software layer above
dmaengine. For example, SCSI subsystem sets the limit of max number of
sglist entries. That is, it is possible that software layer above
dmaengine could set dma limit, which is smaller than the limit of
dmaengine?


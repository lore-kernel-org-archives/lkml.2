Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1FHUmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:42:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36007 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1FHUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:42:01 -0400
Date: Wed, 8 Jun 2011 21:41:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, cjb@laptop.org,
        patches@linaro.org, vinod.koul@intel.com, gregkh@suse.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] dmaengine: add new dma API for
	max_segment_number
Message-ID: <20110608204127.GC13151@n2100.arm.linux.org.uk>
References: <BANLkTin7mqqTsosPHbztaPfL7s_TUGT1qg@mail.gmail.com> <20110608142121T.fujita.tomonori@lab.ntt.co.jp> <BANLkTi=FcNncT_6HpvB_6OnQ94f0_sz7Gw@mail.gmail.com> <20110608160844E.fujita.tomonori@lab.ntt.co.jp> <BANLkTikFKr+3Qph+CR40SUV-DCir1v=KBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikFKr+3Qph+CR40SUV-DCir1v=KBg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 01:05:57PM -0700, Dan Williams wrote:
> Even if that were the case it would be same situation that the scsi device
> driver reports maximum parameters, but the subsystem opts for
> something tighter.  Whether the maximal parameters come from the scsi
> device or the dma channel is moot.

Except for the small issue that many DMA-engine using devices do not
have _any_ DMA capabilities of their own, which means they don't have
anything to put in their own struct device's DMA parameters.  We can't
go around making up random insane parameters in the hope that they'll
exceed whatever DMA-engine is being used with the device - that's a
hack not a solution.

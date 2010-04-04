Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab0DDJHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 05:07:46 -0400
Received: from 8bytes.org ([88.198.83.132]:40664 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab0DDJHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 05:07:41 -0400
Date: Sun, 4 Apr 2010 11:07:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: tek-life <teklife.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Can we remove the Zone_DMA?
Message-ID: <20100404090740.GV24846@8bytes.org>
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 12:21:54PM +0800, tek-life wrote:
> I’m a newbie on the linux kernel. Now I am reading the source code of
> Linux . I have a question in the following about ZONE_DMA.
> 
> 
> In Linux , The Memory is divided to three zone. They are ZONE_DMA
> 、ZONE_NORMAL  and ZONE_HIGHMEM. From the book of "Undstand the Linux
> kernel ", the ZONE_DMA has the effect that the Direct Memory Access
> (DMA) processors for old ISA buses have a strong limitation: they are
> able to address only the first 16 MB of RAM. SO ,we must set a zone
> for  the DMA on ISA bus.  And I suspect that the hardware has
> developed so quickly .And  in this days the ISA has been weeded out.
> And so ,if we not defined the ZONE_DMA, is the system be effected? And
> why not remove ZONE_DMA from the kernel . If it cann‘t to do so，the
> compatibility is the only reason?

There are a couple of reasons to keep ZONE_DMA. It is not used by ISA
device drivers exclusivly. Old style PCI devices may have small DMA
masks (so they could address between 16 MB and 4GB depending on the
device) too. Drivers for these devices often use ZONE_DMA as a fallback
if they can't allocate memory addressable by the device using
ZONE_NORMAL. So there is a use for ZONE_DMA with 32bit PCI too.
(And I also remember I have seen an AM2 board with an ISA slot for
 embedded purposes too, so ISA is not completly dead)

	Joerg


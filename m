Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1CVIr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:47:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab1CVIr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:47:57 -0400
Date: Tue, 22 Mar 2011 04:47:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc0: xfs: kernel BUG at mm/page_alloc.c:738
Message-ID: <20110322084755.GA14129@infradead.org>
References: <AANLkTincs+MyYf+2tt2Y3LMQdmF8PUAxKMxMXuKB72hZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTincs+MyYf+2tt2Y3LMQdmF8PUAxKMxMXuKB72hZ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 04:34:46AM +0300, Alexander Beregalov wrote:
> Hi
> 
> Steps to reproduce:
> run xfs_fsr on xfs device
> 
> arch is x86 UP, kernel is 2.6.38-06507-ga952baa
> 
> kernel BUG at mm/page_alloc.c:738!
> invalid opcode: 0000 [#1]
> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
> Modules linked in: hwmon_vid sata_sil i2c_nforce2

I don't really see anything XFS-specific in here.  The page allocator
is unhappy, and we get there through the generic read code, which just
has a tiny xfs wrapper.


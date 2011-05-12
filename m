Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1ELB0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:26:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab1ELB0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:26:48 -0400
Date: Wed, 11 May 2011 18:33:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Garg <nitingarg98@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: Re: Bug in MTD NAND ONFI chipsize detection
Message-Id: <20110511183322.da0739c9.akpm@linux-foundation.org>
In-Reply-To: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 11:25:22 -0500 Nitin Garg <nitingarg98@gmail.com> wrote:

> Hi All,
> 
> The nand_flash_detect_onfi function in mtd/nand detects the NAND flash
> device size using the ONFI parameters:
> 	chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) * mtd->erasesize;
> 
> The lun_count is not taken into consideration due to which we detect
> wrong size for Micron MT29F8G08ADADAH4 as it has 2 logical units.
> 
> We should change the chipsize calculation to:
> 	chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
> (uint64_t)le32_to_cpu(p->lun_count) * mtd->erasesize;
> 
> Pls suggest.
> 

Please send a tested, changelogged patch to fix it.  Be sure to cc the
relevant maintainer and mailing list.

Thanks.

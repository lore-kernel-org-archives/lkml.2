Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032913Ab2CPPNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:13:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:58252 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032861Ab2CPPNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:13:35 -0400
Subject: Re: [PATCH v3] powerpc/srio: Fix the compile errors when building with 64bit
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1331280638-23525-1-git-send-email-Gang.Liu@freescale.com>
Date: Fri, 16 Mar 2012 10:13:00 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <r61911@freescale.com>,
        <paul.gortmaker@windriver.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5C09B1ED-D607-4924-AB13-4CCB48036133@kernel.crashing.org>
References: <1331280638-23525-1-git-send-email-Gang.Liu@freescale.com>
To: Liu Gang <Gang.Liu@freescale.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 9, 2012, at 2:10 AM, Liu Gang wrote:

> For the file "arch/powerpc/sysdev/fsl_rmu.c", there will be some compile
> errors while using the corenet64_smp_defconfig:
> 
> .../fsl_rmu.c:315: error: cast from pointer to integer of different size
> .../fsl_rmu.c:320: error: cast to pointer from integer of different size
> .../fsl_rmu.c:320: error: cast to pointer from integer of different size
> .../fsl_rmu.c:320: error: cast to pointer from integer of different size
> .../fsl_rmu.c:330: error: cast to pointer from integer of different size
> .../fsl_rmu.c:332: error: cast to pointer from integer of different size
> .../fsl_rmu.c:339: error: cast to pointer from integer of different size
> .../fsl_rmu.c:340: error: cast to pointer from integer of different size
> .../fsl_rmu.c:341: error: cast to pointer from integer of different size
> .../fsl_rmu.c:348: error: cast to pointer from integer of different size
> .../fsl_rmu.c:348: error: cast to pointer from integer of different size
> .../fsl_rmu.c:348: error: cast to pointer from integer of different size
> .../fsl_rmu.c:659: error: cast from pointer to integer of different size
> .../fsl_rmu.c:659: error: format '%8.8x' expects type 'unsigned int',
>                   but argument 5 has type 'size_t'
> .../fsl_rmu.c:985: error: cast from pointer to integer of different size
> .../fsl_rmu.c:997: error: cast to pointer from integer of different size
> 
> Rewrote the corresponding code with the support of 64bit building.
> 
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> Changes in v2:
> - Add the struct "rio_dbell_msg" to instead of some DBELL_* macros.
> - Change the "virt_buf" to be "void *" type.
> - Change "Signed-off-by" to "Reported-by" for Paul.
> 
> Changes in v3:
> - Change the "%8.8lx" to be "%p" and remove the cast of the "buffer"
> 
> arch/powerpc/sysdev/fsl_rmu.c |   42 +++++++++++++++++++++-------------------
> 1 files changed, 22 insertions(+), 20 deletions(-)

applied

- k
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab2CFRqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:46:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:34550 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab2CFRqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:46:52 -0500
Subject: Re: [PATCH] powerpc/srio: Fix the compile errors when building with 64bit
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1330957222.23420.136.camel@10.ap.freescale.net>
Date: Tue, 6 Mar 2012 11:46:20 -0600
Cc: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <r61911@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B946A444-73EC-4A70-AA7E-31FAF31FFF13@kernel.crashing.org>
References: <1330672127-22172-1-git-send-email-Gang.Liu@freescale.com> <6BFCD6C7-7675-4A99-9C4C-4E86FA5642A4@kernel.crashing.org> <1330957222.23420.136.camel@10.ap.freescale.net>
To: Liu Gang <Gang.Liu@freescale.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 5, 2012, at 8:20 AM, Liu Gang wrote:

> Hi, Kumar,
> 
> On Fri, 2012-03-02 at 09:11 -0600, Kumar Gala wrote:
>>> diff --git a/arch/powerpc/sysdev/fsl_rmu.c b/arch/powerpc/sysdev/fsl_rmu.c
>>> index 1548578..468011e 100644
>>> --- a/arch/powerpc/sysdev/fsl_rmu.c
>>> +++ b/arch/powerpc/sysdev/fsl_rmu.c
>>> @@ -311,8 +311,8 @@ fsl_rio_dbell_handler(int irq, void *dev_instance)
>>> 
>>> 	/* XXX Need to check/dispatch until queue empty */
>>> 	if (dsr & DOORBELL_DSR_DIQI) {
>>> -		u32 dmsg =
>>> -			(u32) fsl_dbell->dbell_ring.virt +
>>> +		unsigned long dmsg =
>>> +			(unsigned long) fsl_dbell->dbell_ring.virt +
>>> 			(in_be32(&fsl_dbell->dbell_regs->dqdpar) & 0xfff);

How about a struct instead:

struct rmu_dmsg {
	u16	dummy;
	u16	tid;
	u16	sid;
	u16	info;
};

	struct rmu_dmsg *dmsg = fsl_dbell->dbell_ring.virt + (in_be32(&fsl_dbell->dbell_regs->dqdpar) & 0xfff);

Than you can git rid of the DBELL_* macros.


- k


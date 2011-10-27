Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1J0S2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:28:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:42983 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab1J0S2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:28:35 -0400
Subject: Re: Fix for fsl_upm
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <4EA9683D.8030100@dev.rtsoft.ru>
Date: Thu, 27 Oct 2011 13:28:12 -0500
Cc: benh@kernel.crashing.org, paulus@samba.org, Shengzhou.Liu@freescale.com,
        Shaohui.Xie@freescale.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <4BF2BC2E-1596-42D1-A403-78A1FDBC9EAC@kernel.crashing.org>
References: <4EA9683D.8030100@dev.rtsoft.ru>
To: Rusev <arusev@dev.rtsoft.ru>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 27, 2011, at 9:18 AM, Rusev wrote:

> patch is vs. 2.6.39, yet it applied to 3.1
> 
> 
> 
> Fix of UPM driver for Freescale PowerPC processors
> 
> If Freescale LBC driver fails to initialise itself from device tree,
> then internal structure is freed only but not NULL-fied.
> As result functions fsl_lbc_find() after checking the structure is not NULL are
> trying to access device registers.
> 
> Signed-off-by: Alexandre Rusev <arusev@dev.rtsoft.ru> 
> --- linux-2.6.39.old/arch/powerpc/sysdev/fsl_lbc.c	2011-10-27 03:17:28.000000000 +0400
> +++ linux-2.6.39/arch/powerpc/sysdev/fsl_lbc.c	2011-10-27 05:06:44.000000000 +0400
> @@ -322,6 +322,7 @@ static int __devinit fsl_lbc_ctrl_probe(
> err:
> 	iounmap(fsl_lbc_ctrl_dev->regs);
> 	kfree(fsl_lbc_ctrl_dev);
> +	fsl_lbc_ctrl_dev = NULL;
> 	return ret;
> }
> 

Can you send this as a proper patch.

- k


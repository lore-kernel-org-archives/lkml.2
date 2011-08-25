Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1HYOYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:24:44 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38188 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab1HYOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:24:43 -0400
X-Sasl-enc: j46SD4o1BUc/ucTHrz/LUfOKIT+5O/xSsUysAXe2Dvm9 1314282282
Date: Thu, 25 Aug 2011 07:08:20 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-ID: <20110825140820.GA9126@kroah.com>
References: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 04:18:43PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/tty/ehv_bytechan.c: In function 'udbg_init_ehv_bc':
> drivers/tty/ehv_bytechan.c:230:18: error: 'MSR_GS' undeclared (first use in this function)
> drivers/tty/ehv_bytechan.c: In function 'ehv_bc_console_write':
> drivers/tty/ehv_bytechan.c:289:24: warning: cast from pointer to integer of different size
> drivers/tty/ehv_bytechan.c: In function 'ehv_bc_console_init':
> drivers/tty/ehv_bytechan.c:355:24: warning: cast to pointer from integer of different size
> 
> Caused by commit dcd83aaff1c8 ("tty/powerpc: introduce the ePAPR embedded
> hypervisor byte channel driver").
> 
> MSR_GS is defined in arch/powerpc/include/asm/reg_booke.h which is
> included by arch/powerpc/include/asm/reg.h but only when defined
> (CONFIG_BOOKE) || defined(CONFIG_40x).

Thanks for the report.

Timur, care to send a fixup patch for this so this gets resolved?

greg k-h

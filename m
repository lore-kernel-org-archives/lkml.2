Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab2AEXV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:21:58 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53057 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758262Ab2AEXVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:21:49 -0500
X-Sasl-enc: UOHtEHflSBPFr2zbBahMui/WDr4uOFGT5a+bM/o87jJd 1325805708
Date: Thu, 5 Jan 2012 15:20:34 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jan Beulich <JBeulich@suse.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20120105232034.GB15643@kroah.com>
References: <20120105172856.07fc66f37d76f16a88d22799@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105172856.07fc66f37d76f16a88d22799@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 05:28:56PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> arch/x86/kernel/microcode_core.c: In function 'microcode_init':
> arch/x86/kernel/microcode_core.c:557:2: error: implicit declaration of function 'sysdev_driver_unregister' [-Werror=implicit-function-declaration]
> arch/x86/kernel/microcode_core.c:557:28: error: 'cpu_sysdev_class' undeclared (first use in this function)
> arch/x86/kernel/microcode_core.c:557:47: error: 'mc_sysdev_driver' undeclared (first use in this function)
> 
> Caused by commit 8a25a2fd126c ("cpu: convert 'cpu' and 'machinecheck'
> sysdev_class to a regular subsystem") interacting with commit
> bd399063976c ("x86, microcode: Fix the failure path of microcode update
> driver init code") which was added to Linux' tree in v3.2-rc5,
> 
> I have applied the following merge fix patch:

Thanks, this looks good, and I'll queue it up when push these to Linus.

greg k-h

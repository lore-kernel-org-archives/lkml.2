Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1EESlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:41:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:43284 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1EESlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:41:21 -0400
Date: Thu, 5 May 2011 20:41:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Hoffmann <email@christianhoffmann.info>
cc: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
In-Reply-To: <4DC2E298.4090603@christianhoffmann.info>
Message-ID: <alpine.LFD.2.02.1105052040280.3005@ionos>
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info>  <1304470839.3037.12.camel@work-vm> 
 <4DC100D0.1030302@christianhoffmann.info> <1304558210.2943.24.camel@work-vm> <alpine.LFD.2.02.1105051025290.3005@ionos> <4DC2E298.4090603@christianhoffmann.info>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Christian Hoffmann wrote:
> On 05/05/2011 10:25 AM, Thomas Gleixner wrote:
> I can now select clocksource=acpi_pm as kernel parameter. The boot still hangs
> after "MSI quirk detected...", but the timestamps in dmesg don't show the jump
> anymore.
> 
> [    1.426107] NET: Registered protocol family 1
> [    1.426162] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
> [    2.300212] pci 0000:01:05.0: Boot video device
> [    2.300226] PCI: CLS 64 bytes, default 64

That's because pmtimer wraps around several times in 140 seconds :)

Thanks,

	tglx

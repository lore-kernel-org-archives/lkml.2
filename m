Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0EKPYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:24:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37572 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752823Ab0EKPYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:24:41 -0400
Date: Tue, 11 May 2010 16:30:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH 4/8] x86/mrst: change clock selection logic to support
 medfield
Message-ID: <20100511163054.365239fe@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1005111546260.3401@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-5-git-send-email-jacob.jun.pan@linux.intel.com>
	<alpine.LFD.2.00.1005111546260.3401@localhost.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	pr_debug("cpuid result %x\n", regs[CR_EAX]);
> > +	pr_info("Moorestown CPU %s identified\n",
> > +		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
> > +		"Lincroft" : "Penwell");
> 
>   Are we going to add one of those for each new family ? This is
>   really redundant bloat with no value.
> 
> > +	return mrst_cpu_chip;

>From the driver side we need this value determined and visible to the
drivers because some things like the IPC interface need to know rather
than getting the cpuid magic replicated around.


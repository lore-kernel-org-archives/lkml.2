Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab1EIMjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:39:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab1EIMjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:39:20 -0400
Date: Mon, 9 May 2011 08:39:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        kexec@lists.infradead.org
Subject: Re: [Bug] Kdump does not work when panic triggered due to MCE
Message-ID: <20110509123902.GA5975@redhat.com>
References: <20110506165412.GB2719@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506165412.GB2719@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 10:24:12PM +0530, K.Prasad wrote:
> Hi All,
> 	I wanted to test the behaviour of kdump when panic is triggered
> due to MCE on x86 and found that kdump is not captured.
> 
> While the kdump service is configured and running and non-MCE panics
> (such as those triggered through to /proc/sysrq-trigger) successfully
> capture a kdump, any fatal MCE error injected through the mce-inject
> tool causes a reboot of the machine.
> 
> The code has been traced (using early_serial_putc()) to enter the kexec
> path i.e. panic()->crash_kexec()->machine_kexec()->relocate_kernel()
> but is untraceable further.
> 
> Kdump works fine when the same the similar test is carried out inside a
> KVM guest.
> 
> Has anybody tested this before? Or have found kdump working when fatal
> MCEs have actually occurred?

Prasad,

I have never tried taking dump in MCE situation. Does kdump work on this
machine with normal panic()?

Use --debug and --serial option in kexec-tools to print some debug message
and look for "I am in purgatory". This will tell you whether you hanged
in first kernel or second kernel.

Then put "outb()" messages in the kernel to trace what happened. 

Thanks
Vivek

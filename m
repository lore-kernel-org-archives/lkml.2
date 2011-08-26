Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1HZM3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:29:55 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35878 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab1HZM3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:29:54 -0400
Subject: Re: [PATCH 0/9] x86 EFI boot stub
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4E441774.2040904@gmail.com>
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
	 <4E43D3AE.70901@gmail.com>
	 <1313075678.3436.69.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4E441774.2040904@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 13:29:52 +0100
Message-ID: <1314361792.3577.5.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 19:55 +0200, Maarten Lankhorst wrote: 
> > Hmm.. do you have early printk enabled? Can you hook up a serial console
> > to this machine?
> >
> I get no output on serial console with vmlinuz.efi so it crashes
> before 'early console in decompress_kernel' is printed.

Hey Maarten, sorry I took so long to respond to this.

OK, so you don't get any output on the serial console. Were you passing
"console=" on the kernel cmdline? If so, the best way to debug this hang
is to add,

	efi_call_phys4(sys_table->runtime->reset_system, EFI_RESET_COLD,
			EFI_SUCCESS, 0, NULL);

just after we setup 'sys_table' in efi_main(). If your machine resets,
then we at least know that the firmware loaded the bzImage correctly.

P.S which machine is this and what is the output of the 'ver' command?

-- 
Matt Fleming, Intel Open Source Technology Center


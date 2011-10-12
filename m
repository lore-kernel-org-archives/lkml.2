Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1JLVco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:32:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34150 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1JLVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:32:43 -0400
Message-ID: <4E960746.90805@zytor.com>
Date: Wed, 12 Oct 2011 14:31:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab> <20111012204048.GA22260@phenom.oracle.com>
In-Reply-To: <20111012204048.GA22260@phenom.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 01:40 PM, Konrad Rzeszutek Wilk wrote:
> Why is it paramount to do it as early as possible? As in, even doing
> it before Linux kernel is invoked is preferred than during initrd runtime?

It is paramount to do it as early as possible *because the CPU is 
broken*.  That's why there is a microcode update at all.  It is 
*supposed* to be installed by BIOS, but for whatever reason it wasn't 
(including user doesn't want to update the BIOS), so the very fact that 
this is done in the OS at all is a bit of a fail.

Doing it in the bootloader is messy because bootloaders typically aren't 
SMP-aware (and really shouldn't need to be), which leaves the OS.  On 
native hardware it should ideally be done as early in the processor 
bringup as possible.

	-hpa

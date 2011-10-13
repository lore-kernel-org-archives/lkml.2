Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab1JMQos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:44:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39286 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab1JMQor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:44:47 -0400
Message-ID: <4E971557.1050706@zytor.com>
Date: Thu, 13 Oct 2011 09:44:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab> <20111012204048.GA22260@phenom.oracle.com> <4E960746.90805@zytor.com> <20111012214013.GD28723@aftab> <4E96198F.4030906@zytor.com> <20111013073352.GB501@aftab> <20111013095708.GA1862@aftab>
In-Reply-To: <20111013095708.GA1862@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 02:57 AM, Borislav Petkov wrote:
> On Thu, Oct 13, 2011 at 03:33:52AM -0400, Borislav Petkov wrote:
>> Bottomline is, extending initrd handling to deal with multiple initrd
>> images might turn out to be easier to do than the linked list deal.
> 
> Alternatively and IMHO, we could avoid the bootloader enabling by
> making the ucode part of the initramfs and pull up some of the
> prepare_namespace() work in kernel_init() before smp_init() so that we
> can have it ready for when bootstrapping the cores.
> 

I think that is really ugly, and it also makes it much harder to get the
microcode patch in early on the BSP.  There are enough issues where we
would like to get the microcode in early even on the BSP.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


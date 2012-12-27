Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab2L0BIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 20:08:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:55171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2L0BIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 20:08:00 -0500
Message-ID: <50DB9FA5.6070704@infradead.org>
Date: Wed, 26 Dec 2012 17:08:53 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: David Rientjes <rientjes@google.com>,
        Sasha Levin <levinsasha928@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip] config: Add 'make kvmconfig'
References: <1356040315.3198.51.camel@shinybook.infradead.org>  <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>  <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com> <1356564746.7010.56.camel@shinybook.infradead.org>
In-Reply-To: <1356564746.7010.56.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/12 15:32, David Woodhouse wrote:
> On Tue, 2012-12-25 at 22:32 -0800, David Rientjes wrote:
>>
>> This creates quite a few build failures on auto-latest:
>>
>> arch/x86/built-in.o: In function `hpet_setup_msi_irq':
>> hpet.c:(.text+0x34638): undefined reference to `arch_setup_hpet_msi'
>> hpet.c:(.text+0x34651): undefined reference to `destroy_irq'
>> arch/x86/built-in.o: In function `hpet_msi_capability_lookup':
>> hpet.c:(.text+0x347ff): undefined reference to `create_irq_nr'
>> arch/x86/built-in.o:(.data+0xd1c): undefined reference to `native_setup_msi_irqs'
>> arch/x86/built-in.o:(.data+0xd20): undefined reference to `native_teardown_msi_irq'

I reported these build errors in linux-next on Nov. 7, 2011 !!!

> This one is actually caused by commit 3b08ed026 (config: Add 'make
> kvmconfig'), which selects PCI_MSI even on a 32-bit config where it's
> invalid to do so.
> 
> Ew, that commit seems like a *completely* wrong-headed idea. That abuse
> of 'select' is just begging for this kind of breakage. We have other
> ways to merge configs and turn certain options on, without doing it this
> way.

but I didn't diagnose the problem.  Thanks for that.

Yes, 'make kvmconfig' takes liberties and shortcuts.  :(

-- 
~Randy

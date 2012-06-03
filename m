Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2FCLXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 07:23:54 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45855 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2FCLXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 07:23:25 -0400
Message-ID: <4FCB48EF.8050508@linux.vnet.ibm.com>
Date: Sun, 03 Jun 2012 16:52:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Richard Kuo <rkuo@codeaurora.org>, David Howells <dhowells@redhat.com>,
        Bob Liu <lliubbo@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Matt Turner <mattst88@gmail.com>, nikunj@linux.vnet.ibm.com
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot secondary
 processors
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <4FC8B0F7.3060705@linux.vnet.ibm.com> <20120603085107.GD16829@zhy>
In-Reply-To: <20120603085107.GD16829@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12060301-7014-0000-0000-0000014EF825
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2012 02:21 PM, Yong Zhang wrote:

> On Fri, Jun 01, 2012 at 05:39:27PM +0530, Srivatsa S. Bhat wrote:
>> +/* Implement the following functions in your architecture, as appropriate. */
>> +
>> +/**
>> + * __cpu_pre_starting()
>> + *
>> + * Implement whatever you need to do before the CPU_STARTING notifiers are
>> + * invoked. Note that the CPU_STARTING callbacks run *on* the cpu that is
>> + * coming up. So that cpu better be prepared! IOW, implement all the early
>> + * boot/init code for the cpu here. And do NOT enable interrupts.
>> + */
>> +#ifndef __cpu_pre_starting
> 
> Why the ifndef?
> 


In short, to avoid breaking build on x86.
We wanted to follow the x86 convention of having static inline functions in
arch/x86/include/asm/smp.h and use the smp_ops structure to route the calls
to x86 or xen as appropriate (see patch 4 in this series).

But __weak definitions interfere with that and break the build. Hence, we
followed what Linus suggested doing in a similar context:
https://lkml.org/lkml/2008/7/26/187

Regards,
Srivatsa S. Bhat

> 

>> +void __weak __cpu_pre_starting(void *arg) {}
>> +#endif
>> +
>> +/**
>> + *  __cpu_pre_online()
>> + *
>> + * Implement whatever you need to do before the upcoming CPU is set in the
>> + * cpu_online_mask. (Setting the cpu in the cpu_online_mask is like an
>> + * announcement that the cpu has come up, because it would be publicly
>> + * visible now). Again, don't enable interrupts.
>> + */
>> +#ifndef __cpu_pre_online
>> +void __weak __cpu_pre_online(void *arg) {}
>> +#endif
>> +



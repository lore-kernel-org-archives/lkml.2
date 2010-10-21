Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0JUROc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:14:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33252 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0JUROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:14:31 -0400
Message-ID: <4CC074B4.7070708@oracle.com>
Date: Thu, 21 Oct 2010 10:13:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21 (xen)
References: <20101021151529.392fecea.sfr@canb.auug.org.au> <20101021091316.0587c1a8.randy.dunlap@oracle.com> <20101021163225.GA2456@dumpdata.com> <alpine.DEB.2.00.1010211738530.10348@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1010211738530.10348@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/10 09:53, Stefano Stabellini wrote:
> On Thu, 21 Oct 2010, Konrad Rzeszutek Wilk wrote:
>> On Thu, Oct 21, 2010 at 09:13:16AM -0700, Randy Dunlap wrote:
>>> On Thu, 21 Oct 2010 15:15:29 +1100 Stephen Rothwell wrote:
>>>
>>>> Hi all,
>>>>
>>>> Reminder: do not add 2.6.38 destined stuff to linux-next until after
>>>> 2.6.37-rc1 is released.
>>>>
>>>> Changes since 20101020:
>>>
>>>
>>> When CONFIG_SMP is not enabled:
>>>
>>> arch/x86/pci/xen.c:401: error: 'nr_ioapics' undeclared (first use in this function)
>>
>> Thank you,
>>
>> Stefano, this one is yours.
>>
> 
> Yep.
> It was a missing #include in arch/x86/pci/xen.c, I fixed it adding a
> commit to my linux-next branch.

Ack.  Thanks.

> ---
> 
> commit fa4c2e29e4a30dc3e9d3f83944eeea63f78350a5
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Thu Oct 21 17:40:08 2010 +0100
> 
>     xen: add a missing #include to arch/x86/pci/xen.c
>     
>     Add missing #include <asm/io_apic.h> to arch/x86/pci/xen.c.
>     
>     Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 4f5df3d..4a32df2 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -10,6 +10,7 @@
>  #include <linux/acpi.h>
>  
>  #include <linux/io.h>
> +#include <asm/io_apic.h>
>  #include <asm/pci_x86.h>
>  
>  #include <asm/xen/hypervisor.h>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

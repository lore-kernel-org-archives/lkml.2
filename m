Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab0JYX5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:57:31 -0400
Received: from claw.goop.org ([74.207.240.146]:44354 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542Ab0JYX5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:57:30 -0400
Message-ID: <4CC61963.9090708@goop.org>
Date: Mon, 25 Oct 2010 16:57:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: build failure after merge of the xen tree
References: <20101025133021.53649fd1.sfr@canb.auug.org.au> <1287995906.11851.14219.camel@zakaz.uk.xensource.com>
In-Reply-To: <1287995906.11851.14219.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/25/2010 01:38 AM, Ian Campbell wrote:
> On Mon, 2010-10-25 at 03:30 +0100, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the xen tree, today's linux-next build (s86_64 allmodconfig)
>> failed like this:
>>
>> arch/x86/xen/setup.c: In function 'xen_memory_setup':
>> arch/x86/xen/setup.c:161: error: implicit declaration of function 'xen_initial_domain'
>>
>> Caused by commit 9e9a5fcb04e3af077d1be32710298b852210d93f ("xen: use host
>> E820 map for dom0").  See Rule 1 from Documentation/SubmitChecklist.
>>
>> I have used the xen tree from next-20101021 for today (due to the complex
>> conflict in Friday's tree).
> Sorry about that, there was a missing #include which was hidden for me
> by a change in the swiotlb-xen tree (d8e0420603cf "xen: define
> BIOVEC_PHYS_MERGEABLE()", FWIW). We shouldn't be relying on indirect
> includes in that way so:

Thanks, fixed.

    J

> 8<-----
>
> Subject: xen: include xen/xen.h for definition of xen_initial_domain()
>
>           CC      arch/x86/xen/setup.o
>         arch/x86/xen/setup.c: In function 'xen_memory_setup':
>         arch/x86/xen/setup.c:161: error: implicit declaration of function 'xen_initial_domain'
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>
> --- arch/x86/xen/setup.c.orig	2010-10-25 09:31:42.000000000 +0100
> +++ arch/x86/xen/setup.c	2010-10-25 09:31:49.000000000 +0100
> @@ -18,6 +18,7 @@
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
>  
> +#include <xen/xen.h>
>  #include <xen/page.h>
>  #include <xen/interface/callback.h>
>  #include <xen/interface/memory.h>
>
>


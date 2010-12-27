Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0L0UMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 15:12:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41897 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0L0UMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 15:12:43 -0500
Message-ID: <4D18F332.5090904@zytor.com>
Date: Mon, 27 Dec 2010 12:12:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Len Brown <lenb@kernel.org>, Jack Steiner <steiner@sgi.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] ACPI: use ioremap_cache()
References: <20101214220932.GA1206@sgi.com>	<alpine.LFD.2.00.1012141903210.25387@x980>	<20101215024136.GB19601@sgi.com>	<alpine.LFD.2.00.1012142302110.4878@x980>	<20101215164635.GA27373@sgi.com>	<alpine.LFD.2.00.1012151536510.21167@x980>	<alpine.LFD.2.00.1012162149370.20940@x980>	<alpine.LFD.2.00.1012170307080.20940@x980> <AANLkTin7WmYo47JvCMSjExkZ8o2rPajB3fOxU80-UdE1@mail.gmail.com>
In-Reply-To: <AANLkTin7WmYo47JvCMSjExkZ8o2rPajB3fOxU80-UdE1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2010 11:42 AM, Tony Luck wrote:
> On Fri, Dec 17, 2010 at 12:08 AM, Len Brown <lenb@kernel.org> wrote:
>> No change on ia64.
> 
> Apart from breaking the build :-(
> 
>> +++ b/arch/ia64/include/asm/io.h
>    ...
>> +static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
>> +{
>> +       return ioremap(unsigned long phys_addr, unsigned long size);
>> +}
> 
> Cut & paste issue? ... the compiler would be a lot happier
> without the "unsigned long"s in the call to ioremap().
> 

LOL...

In the long(er) run it might be worth considering having the same policy
on IA64 as on x86 -- ioremap() meaning ioremap_nocache().

	-hpa


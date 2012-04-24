Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab2DXUBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:01:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62828 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab2DXUBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120424055123.GA7140@burratino>
References: <1322640100-14534-1-git-send-email-mcree@orcon.net.nz> <20120424055123.GA7140@burratino>
From: Matt Turner <mattst88@gmail.com>
Date: Tue, 24 Apr 2012 16:01:28 -0400
Message-ID: <CAEdQ38HE70B-4w3t71rn_S-eX7BMnc6f=dD49guuBim+dQnPzA@mail.gmail.com>
Subject: Re: [PATCH] alpha: add io{read,write}{16,32}be functions
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Ben Hutchings <ben@decadent.org.uk>,
        =?ISO-8859-1?Q?Ra=FAl_Porcel?= <armin76@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 1:51 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Hi Matt et al,
>
> Michael Cree wrote:
>
>> These functions are used in some PCI drivers with big-endian
>> MMIO space.
>>
>> Admittedly it is almost certain that no one this side of the
>> Moon would use such a card in an Alpha but it does get us
>> closer to being able to build allyesconfig or allmodconfig,
> [...]
>> --- a/arch/alpha/include/asm/io.h
>> +++ b/arch/alpha/include/asm/io.h
>> @@ -490,6 +490,11 @@ extern inline void writeq(u64 b, volatile void __iomem *addr)
>>  }
>>  #endif
>>
>> +#define ioread16be(p) be16_to_cpu(ioread16(p))
>> +#define ioread32be(p) be32_to_cpu(ioread32(p))
>> +#define iowrite16be(v,p) iowrite16(cpu_to_be16(v), (p))
>> +#define iowrite32be(v,p) iowrite32(cpu_to_be32(v), (p))
>> +
>>  #define inb_p                inb
>
> This patch has been in use in Debian's development branch since
> January.  Does it look sensible to you?  (If so, I'd like to see it in
> mainline eventually so we can more easily share bugfixes depending on
> it in the future.)
>
> Thanks,
> Jonathan

I recently got my kernel.org tree set up again, so I just applied this.

Thanks, and please point me to any patches I should apply.

Matt

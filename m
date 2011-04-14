Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab1DNSQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:16:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51343 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658Ab1DNSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=OD/pfAqkjo4wsdLyLoE2A0wcqofW8jVYLARQYYDQtm3YLBsteHy5aBrLAfp1xwmfZu
         BwQglQTXyCabdZ7jmRJkOJN529e3L6GRaHpm3xzNmPqyIwPULZUgTN2uHuCdD7H9kVG5
         Le9tTVa58VRW0X4FLS92PC+TMn81tU615SGPs=
MIME-Version: 1.0
In-Reply-To: <20110414180936.GA20924@redhat.com>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
 <1302760895-13459-2-git-send-email-vapier@gentoo.org> <20110414180936.GA20924@redhat.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 14 Apr 2011 14:16:03 -0400
X-Google-Sender-Auth: qz7Fliv3A0Fs2fIAt5VlcxMvA1s
Message-ID: <BANLkTikxq-xUhYmbE93+aGHoiEEbHWkoWQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] asm-generic/ptrace.h: start a common low level ptrace helper
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 14:09, Oleg Nesterov wrote:
> On 04/14, Mike Frysinger wrote:
>> +#ifndef GET_IP
>> +#define GET_IP(regs) ((regs)->pc)
>> +#endif
>
> Could you explain this ifndef ?
>
> IIUC, this should be included by arch/*/asm/ptrace.h. Isn't it better
> to simply require that if you include asm-generic/ptrace.h you should
> provide the necessary GET_* macros?
>
> (regs)->pc looks a bit strange in asm-generic. But please feel free
> to ignore.

my view of asm-generic is to put as much common/sane-defaults in there
as possible to minimize code duplication in arch code.  when it comes
to the register names, i looked at the arches to see what people used.
while x86 uses "ip", the majority of ports use "pc", thus the
majority of ports wont have to define their own GET_IP helper.
-mike

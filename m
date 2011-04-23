Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1DWRwI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 13:52:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52561 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab1DWRwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 13:52:05 -0400
Message-ID: <4DB3118C.4030505@zytor.com>
Date: Sat, 23 Apr 2011 10:51:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, chris@csamuel.org,
        alan@lxorguk.ukuu.org.uk, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: FW: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel"
 on quad Pentium Pro system
References: <201104222333.25546.chris@csamuel.org>	 <201104231522.06057.chris@csamuel.org>	 <SNT125-W25B0C502FF72465BC6B55BC3940@phx.gbl>	 ,<201104231855.47680.chris@csamuel.org>	 <SNT125-W501A69BD9948F037646EDFC3940@phx.gbl> <1303566747.12067.10.camel@localhost.localdomain>
In-Reply-To: <1303566747.12067.10.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2011 06:52 AM, Thomas Meyer wrote:
>
> so your bios seems to report the size in AX/BX. the code in
> arch/x86/boot/memory.c move the return sizes from CX/DX into AX/BX, when
> CX or DX is not zero.
>
> Could you try to change the line:
>
> 	} else if (oreg.ax == 15*1024) {
> 		boot_params.alt_mem_k = (oreg.dx<<  6) + oreg.ax;
>
> to
> 	} else if (oreg.ax == 15*1024) {
> 		boot_params.alt_mem_k = (oreg.bx<<  6) + oreg.ax;
>
> That should fix your misdetection.
>
> The assembler code in arch/i386/boot/setup.S seemed to move AX/BX into
> CX/DX, when CX and(!) DX were zero. Then used CX/DX to calc the memory
> size.
>
> PS: gitk --follow arch/x86/boot/memory.c seems to react strangley...
>

Ah yes, this should have been bx; ax/bx and cx/dx forms pairs (unlike 
the normal x86 convention of DX:AX and BX:CX forming pairs), and it 
doesn't make sense to mix and match them.

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1G3TGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:06:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41707 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab1G3TGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:06:19 -0400
Message-ID: <4E34548F.9040909@zytor.com>
Date: Sat, 30 Jul 2011 11:59:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid overriding
 CONFIG_64BIT
References: <1306707270.2029.377.camel@i7.infradead.org> <20110530072300.GA9802@elte.hu> <1306745835.2029.389.camel@i7.infradead.org> <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu> <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu> <20110530105809.GA20133@elte.hu> <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu> <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6> <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com> <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6> <1306795186.2029.459.camel@i7.infradead.org> <BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com> <1306856937.27477.3.camel@i7.infradead.org> <BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com> <4E0495F4.7080300@suse.cz> <1311986969.20983.52.camel@i7.infradead.org> <CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com> <alpine.LFD.2.02.1107301716430.21839@localhost6.localdomain6> <CACqU3MVY89L3B3=eFrmsgD2wzXtbQHssPm4D_-VZGEWNYBR4-Q@mail.gmail.com>
In-Reply-To: <CACqU3MVY89L3B3=eFrmsgD2wzXtbQHssPm4D_-VZGEWNYBR4-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2011 09:33 AM, Arnaud Lacombe wrote:
>>
> well, from my point of view, it do not need to be updated. Your patch
> corrupt SUBARCH's purpose, that is:
> 
> # SUBARCH tells the usermode build what the underlying arch is.
> 

For klibc integration, we ran into this problem as well: the set of
architectures for the kernel simply isn't the same set as the
architectures for userspace.  For the kernel, x86 is an architecture,
for userspace the architectures are x86_64 or i386 and they are
fundamentally different in many, many ways.

The main problem with SUBARCH is that it is ill-defined in the general
case if SUBARCH contains a user space or a kernel space architecture.
In that sense I would much prefer it if was called, say, USERARCH and
was always available.  It could even be set by Kconfig (CONFIG_USERARCH?)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1FSXC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:02:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56637 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1FSXC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Mx2jx99mUs73B3XWM/coFXUkbk93MYOqWJPbx0eWBgdo9EA73/wm/kVvgS4vBR9Kfr
         rySn0RZOY1dfCJgv74cP0gQCmO1fvxC37Seaba4ups/Zi9T6S05PnXHPApgxBymBa7Ci
         cuxGeZxT0Fb4875rmaZkb7uikKt5+iFCE3onU=
Message-ID: <4DFE7FF9.9070406@gmail.com>
Date: Mon, 20 Jun 2011 09:02:17 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Petr Tesarik <ptesarik@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu>
In-Reply-To: <20110617093032.GA19235@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/11 19:30, Ingo Molnar wrote:
> * Petr Tesarik<ptesarik@suse.cz>  wrote:
>
>> This patch series enhances /dev/mem, so that read and write is
>> possible at any address. The patchset includes actual
>> implementation for x86.
> This series lacks a description of why this is desired.
>
> My strong opinion is that it's not desired at all: /dev/mem never
> worked beyond 4G addresses so by today it has become largely obsolete
> and is on the way out really.
>
> I'm aware of these current /dev/mem uses:
>
>   - Xorg maps below 4G non-RAM addresses and the video BIOS
>
>   - It used to have some debugging role but these days kexec and kgdb
>     has largely taken over that role - partly due to the 4G limit.
>
>   - there's some really horrible out-of-tree drivers that do mmap()s
>     via /dev/mem, those should be fixed if they want to move beyond
>     4G: their char device should be mmap()able.

There are drivers where this makes sense. For example an FPGA device 
with a proprietary register layout on the memory bus can be done this 
way. The FPGA can simply be mapped in user-space via /dev/mem and 
handled there. If the device requires no access other than memory bus 
reads and writes then writing a custom char device driver just to get an 
mmap function seems a bit overkill.

~Ryan


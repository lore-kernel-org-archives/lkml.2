Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1FTRKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:10:36 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43201 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1FTRKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=buaI7kJA1beeb0ghqe4bpdTqRjrMUQF6FB485D54ZqlVW9Ir5B+UR9H+LJfNZNh04X
         Ff4kmSnThAQ1tAxZ6BXF/9j4jAApcc7Tsa3H1KyNZK7bEcxL8sBSZeCvOJPCagdohL7R
         mE8d0MDSE+6/Q6/XqUSYAi5fObAOL4TOdztIw=
MIME-Version: 1.0
In-Reply-To: <4DFE7FF9.9070406@gmail.com>
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu>
 <4DFE7FF9.9070406@gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 20 Jun 2011 10:10:04 -0700
X-Google-Sender-Auth: wnbmRc0S30OubC9bXxSAWFeutDY
Message-ID: <BANLkTi=kP0LQ4Hx_uA8viA59aDnb1KePyQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
To: Ryan Mallon <rmallon@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Petr Tesarik <ptesarik@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 4:02 PM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 17/06/11 19:30, Ingo Molnar wrote:
>>  - there's some really horrible out-of-tree drivers that do mmap()s
>>    via /dev/mem, those should be fixed if they want to move beyond
>>    4G: their char device should be mmap()able.
>
> There are drivers where this makes sense. For example an FPGA device with a
> proprietary register layout on the memory bus can be done this way. The FPGA
> can simply be mapped in user-space via /dev/mem and handled there. If the
> device requires no access other than memory bus reads and writes then
> writing a custom char device driver just to get an mmap function seems a bit
> overkill.

While VFIO is still out-of-tree, it handles this use-case, as well as
interrupts and transparent DMA remapping via the IOMMU. I'm using it
on a current project and it works as advertised. UIO is in-tree and
also handles this (as I understand it), but without DMA or interrupt
support.

   https://github.com/pugs/vfio-linux-2.6/blob/vfio/Documentation/vfio.txt

It's perhaps arguable whether any human with taste should ship a
driver based on UIO/VFIO, but for code that exists solely to exercise
and test a hardware design, it works great.

~r.

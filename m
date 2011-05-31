Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab1EaQam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:30:42 -0400
Received: from service87.mimecast.com ([94.185.240.25]:57912 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757389Ab1EaQak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:30:40 -0400
Date: Tue, 31 May 2011 17:30:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Will Deacon <Will.Deacon@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Disable -fconserve-stack on ARM
Message-ID: <20110531163026.GB771@e102109-lin.cambridge.arm.com>
References: <yw1xaaeanbxe.fsf@unicorn.mansr.com>
 <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
 <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
 <alpine.LFD.2.00.1105261650330.3207@xanadu.home>
 <20110526215101.GL24876@n2100.arm.linux.org.uk>
 <20110527083806.GA21100@e102109-lin.cambridge.arm.com>
 <20110527085414.GP24876@n2100.arm.linux.org.uk>
 <20110527095111.GC21100@e102109-lin.cambridge.arm.com>
 <yw1xlixse2fl.fsf@unicorn.mansr.com>
 <20110528153417.GB25869@alboin.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <20110528153417.GB25869@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 May 2011 16:30:52.0928 (UTC) FILETIME=[1BE02000:01CC1FB0]
X-MC-Unique: 111053117303601601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 04:34:17PM +0100, Andi Kleen wrote:
> Disable -fconserve-stack on ARM
> 
> There are reports that -fconserve-stack misaligns variables on the stack.
> Disable it for ARM to work around this gcc bug.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 25750bc..0883cff 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -41,6 +41,10 @@ ifeq ($(CONFIG_CC_STACKPROTECTOR),y)
>  KBUILD_CFLAGS  +=-fstack-protector
>  endif
> 
> +# ARM gcc developers unfortunately broke -fconserve-stack. It misaligns
> +# variables on the stack
> +KBUILD_CFLAGS += $(call cc-option,-fno-conserve-stack)

Didn't work, on the gcc command line we get -fno-conserve-stack followed
by -fconserve-stack from the top makefile and it seems that the latter
takes priority.

-- 
Catalin


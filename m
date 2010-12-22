Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0LVTBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 14:01:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab0LVTBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 14:01:47 -0500
Date: Wed, 22 Dec 2010 14:01:08 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH v2] x86, nmi_watchdog:  Remove ARCH_HAS_NMI_WATCHDOG and
 rely on CONFIG_HARDLOCKUP_DETECTOR
Message-ID: <20101222190108.GE3743@redhat.com>
References: <1293027942-7599-1-git-send-email-dzickus@redhat.com>
 <20101222162452.GA23665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101222162452.GA23665@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 05:24:52PM +0100, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > Tested with
> > ARCH=i386: allnoconfig, defconfig, allyesconfig, (various broken configs)
> > ARCH=x86_64: allnoconfig, defconfig, allyesconfig, (various broken configs)
> > 
> > Hopefully, after this patch I won't get any more compile broken emails. :-)
> > 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> 
> There's still some assumptions in the oprofile code, which breaks the build with 
> your patch applied:
> 
>  arch/x86/oprofile/op_model_p4.c:394:4: error: implicit declaration of function ‘release_perfctr_nmi’
>  arch/x86/oprofile/op_model_p4.c:403:4: error: implicit declaration of function ‘release_evntsel_nmi’
>  arch/x86/oprofile/op_model_p4.c:419:3: error: implicit declaration of function ‘reserve_perfctr_nmi’
>  arch/x86/oprofile/op_model_p4.c:428:3: error: implicit declaration of function ‘reserve_evntsel_nmi’
> 
> Config attached.

Thanks.  I sent a patch to fix this.  Basically they were using
linux/nmi.h instead of asm/nmi.h.

Cheers,
Don

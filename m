Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab1ERCqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 22:46:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39743 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1ERCqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 22:46:45 -0400
Message-ID: <ca1b13fa72e83adbc23b56e0cb28df7a.squirrel@www.firstfloor.org>
In-Reply-To: <1305671358-14478-3-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
    <1305671358-14478-3-git-send-email-fenghua.yu@intel.com>
Date: Wed, 18 May 2011 04:46:43 +0200
Subject: Re: [PATCH 2/9] x86/kernel/cpu/intel.c: Initialize Enhanced REP
 MOVSB/STOSBenhanced
From: "Andi Kleen" <andi@firstfloor.org>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Avi Kivity" <avi@redhat.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Fenghua Yu <fenghua.yu@intel.com>
>
> If kernel intends to use enhanced REP MOVSB/STOSB, it must ensure
> IA32_MISC_ENABLE.Fast_String_Enable (bit 0) is set and CPUID.(EAX=07H,
> ECX=0H):
> EBX[bit 9] also reports 1.

I suspect the check at this place is not too useful because it will
only work for the BSP. For all others it's too late -- the patching
has already happened.

So either this is a problem and then it should be checked on all CPUs.
Or maybe not at all.

The problem is that the alternative patching currently relies on being
run early with no other CPUs. It has no race protections, support
for cross modification etc.

While it would be possible to fix that it would be quite complicated
I bet.

So I think it's better to just remove it unless it's a real problem
in the field.

-Andi


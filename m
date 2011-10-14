Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab1JNQ4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:56:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43329 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab1JNQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:56:19 -0400
Date: Fri, 14 Oct 2011 18:56:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tejun Heo <tj@kernel.org>
Cc: "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:1239 setup_local_APIC+...
Message-ID: <20111014165604.GA14286@aftab>
References: <20111014135516.GC11990@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014135516.GC11990@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 09:55:16AM -0400, Borislav Petkov wrote:
> So, in the end, and AFAICR, the warning triggers because we're comparing
> logical APIC IDs from the APIC Logical Destination Register (0xD0) which
> have been assigned by BIOS with "1 << cpu" shifted values which wrap on
> 32-bit.
> 
> I'd very much like to know why?

Update: upon a second thought, we think we know why: The WARN_ON
cannot stomach the switch to bigsmp apic because, on the one hand,
bigsmp_init_apic_ldr() "normalizes" the APIC ids by using the BIOS
values (x86_bios_cpu_apicid) but OTOH, x86_cpu_to_logical_apicid
contains the early percpu value which got assigned by the default apic,
i.e. the shifting thing as it is spec'ed for the LDR register.

So, the way we see it, the WARN_ON should know whether we switched apics
or should be removed completely. Btw, why was it added in the first
place, the commit message doesn't quite explain why.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

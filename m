Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0GMDdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 23:33:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33793 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0GMDdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 23:33:52 -0400
Message-ID: <4C3BDDA3.2060900@kernel.org>
Date: Mon, 12 Jul 2010 20:29:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tip/master broken with x2apic and kexec
References: <4C3BD6AA.3070908@kernel.org>
In-Reply-To: <4C3BD6AA.3070908@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C3BDE99.0028,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 07:59 PM, Yinghai Lu wrote:
> tip/master: 
> system1: BIOS enabled x2apic, first kernel boot well, and when kexec second kernel will cause system instant reboot.
> 
> system2: BIOS not enable x2apic, first kernel boot well and enable x2apic, and kexec second kernel well. but when kexec third kernel will case system instant reboot.
> 
> linus' tree is ok.
> 
> but for system2 if boot with nox2apic ,intr-remaping off, iommu off, the kexec loop test will pass.
> 
> the problem looks start in recent two or three weeks.
> 

offending patch is

commit 83a7a2ad2a9173dcabc05df0f01d1d85b7ba1c2c
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Thu Jun 10 00:10:43 2010 +0000

    x86, alternatives: Use 16-bit numbers for cpufeature index
    
    We already have cpufeature indicies above 255, so use a 16-bit number
    for the alternatives index.  This consumes a padding field and so
    doesn't add any size, but it means that abusing the padding field to
    create assembly errors on overflow no longer works.  We can retain the
    test simply by redirecting it to the .discard section, however.
    
    [ v3: updated to include open-coded locations ]
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    LKML-Reference: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab2E3Oue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:50:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39021 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab2E3Oud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:50:33 -0400
Message-ID: <4FC633A7.1050406@zytor.com>
Date: Wed, 30 May 2012 07:50:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Andre Przywara <andre.przywara@amd.com>, mingo@elte.hu, tglx@linutronix.de,
        jeremy@goop.org, xen-devel@lists.xensource.com,
        stable@vger.kernel.org#3.4+, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <20120530143937.GF3207@phenom.dumpdata.com>
In-Reply-To: <20120530143937.GF3207@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 07:39 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, May 30, 2012 at 03:10:02PM +0200, Andre Przywara wrote:
>> Because we are behind a family check before tweaking the topology
>> bit, we can use the standard rd/wrmsr variants for the CPUID feature
>> register.
>> This fixes a crash when using the kernel as a Xen Dom0 on affected
>> Trinity systems. The wrmsrl_amd_safe is not properly paravirtualized
>> yet (this will be fixed in another patch).
> 
> So with a rdmsrl_amd_safe and wrmsrl_amd_safe being implemented in
> the pv_cpu_ops - would this patch even be neccessary?
> 

That is still bogus;  a better thing would be to implement the _regs
interface.  Even better would be to trap and emulate rdmsr/wrmsr!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


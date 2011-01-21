Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1AUSUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:20:19 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:29654 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753166Ab1AUSUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:20:16 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Hia3cwAVM1mZ3gnWo3r2xVUSEQT57HOZzkmTUwD3GM1meUG
 3Oc_D6V3otokrdDrPS9Z7bCQ5RunXHPILExt8m_iBPxgjRUTzftZrStSGBve
 XyCGO813fTIDy0Rvvealftn8PvMc2kql9Q_amugLUScXegfmGAlxWRWe49aK
 A8DTKgqZXAiX.b7IRmGZLPDuyv0qt1N6FDc_e0VAeS4egcvoM93VOYre1G9C
 O
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 12:20:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
In-Reply-To: <20110121181250.GA22824@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1101211215220.15692@router.home>
References: <alpine.DEB.2.00.1012151404070.21102@router.home> <20110121171133.GI2832@htj.dyndns.org> <alpine.DEB.2.00.1101211114530.15692@router.home> <20110121172836.GK2832@htj.dyndns.org> <alpine.DEB.2.00.1101211139330.15692@router.home>
 <20110121174817.GM2832@htj.dyndns.org> <alpine.DEB.2.00.1101211155150.15692@router.home> <20110121181250.GA22824@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Jan 2011, Tejun Heo wrote:

> On Fri, Jan 21, 2011 at 11:57:09AM -0600, Christoph Lameter wrote:
> > > Hmm?  asm/percpu.h gets included by linux/percpu.h, so it would end up
> > > in most .c files.
> >
> > The function is defined in arch/x86/include/asm/percpu.h. At least my
> > patches here are that way.
> >
> > #include "asm/percpu.h" will get you include/asm-generic/percpu.h on
> > other arches.
>
> Yeah, I was referring to generic code having visibility to the x86
> specific this_cpu op which isn't available on other archs.  I don't
> feel too strong about it so if you don't like it, just add a comment.

The code segments in generic code that use this function are in #ifdef
CONFIG_X86 sections.

Where do you want me to add a comment?

In include/x86/include/asm/percpu.h saying that the operations defined
there are x86 specific? Or in the #ifdef CONFIG_X86 sections saying that
the this_cpu_has operations are x86 specific?



Code snippet from drivers/acpi/processor_throttling.c

...

#ifdef CONFIG_X86
static int acpi_throttling_rdmsr(u64 *value)
{
        u64 msr_high, msr_low;
        u64 msr = 0;
        int ret = -1;

        if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||
                !this_cpu_has(X86_FEATURE_ACPI)) {
                printk(KERN_ERR PREFIX
                        "HARDWARE addr space,NOT supported yet\n");
        } else {
                msr_low = 0;
                msr_high = 0;
                rdmsr_safe(MSR_IA32_THERM_CONTROL,
                        (u32 *)&msr_low , (u32 *) &msr_high);
                msr = (msr_high << 32) | msr_low;
                *value = (u64) msr;
                ret = 0;
        }
        return ret;
}



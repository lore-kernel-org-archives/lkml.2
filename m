Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab0LQVKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:10:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:19399 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0LQVKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:10:54 -0500
X-Greylist: delayed 843 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Dec 2010 16:10:53 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wVi5uqbWGdHS9jKwwoWKWMR4X3XTOFmH5KB1nSXxH9uRWmG6ryWWwfg7eoIluAQ72d
         pf0awYE85VG9BUB1l6ng==
Date: Fri, 17 Dec 2010 12:56:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] x86, acpi: add MAX_LOCAL_APIC for 32bit
In-Reply-To: <4D0AD464.2020408@kernel.org>
Message-ID: <alpine.DEB.2.00.1012171253520.30929@chino.kir.corp.google.com>
References: <20101111100628.GA24728@localhost> <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost>
 <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost> <4CDEE314.6090107@kernel.org> <20101113235746.GA9458@localhost> <4CDF3DA1.2090806@kernel.org> <4D093ABB.4030206@zytor.com> <4D0943D5.1090404@kernel.org> <4D094703.7080701@zytor.com>
 <4D0AD464.2020408@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010, Yinghai Lu wrote:

> Index: linux-2.6/arch/x86/include/asm/apicdef.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/apicdef.h
> +++ linux-2.6/arch/x86/include/asm/apicdef.h
> @@ -145,6 +145,7 @@
>  
>  #ifdef CONFIG_X86_32
>  # define MAX_IO_APICS 64
> +# define MAX_LOCAL_APIC 256
>  #else
>  # define MAX_IO_APICS 128
>  # define MAX_LOCAL_APIC 32768
> Index: linux-2.6/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
> +++ linux-2.6/arch/x86/kernel/apic/apic.c
> @@ -1689,7 +1689,7 @@ void __init register_lapic_address(unsig
>   * This initializes the IO-APIC and APIC hardware if this is
>   * a UP kernel.
>   */
> -int apic_version[MAX_APICS];
> +int apic_version[MAX_LOCAL_APIC];
>  
>  int __init APIC_init_uniprocessor(void)
>  {
> Index: linux-2.6/arch/x86/include/asm/mpspec.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/mpspec.h
> +++ linux-2.6/arch/x86/include/asm/mpspec.h
> @@ -6,7 +6,7 @@
>  #include <asm/mpspec_def.h>
>  #include <asm/x86_init.h>
>  
> -extern int apic_version[MAX_APICS];
> +extern int apic_version[];
>  extern int pic_mode;
>  
>  #ifdef CONFIG_X86_32
> 

This looks like it duplicates and conflicts with Tejun's NUMA unification 
patchset, specifically http://marc.info/?l=linux-kernel&m=129087155712396

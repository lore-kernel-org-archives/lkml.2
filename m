Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1FOCGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:06:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab1FOCGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=blVNLSGPKB6620w8xaEG8i6dvcME3JmGM4OztlFtUBbewL+RqSBgfjQCal/bSWORZf
         PEY4OipXETR4SdbdbzKA==
Date: Tue, 14 Jun 2011 19:05:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: cfowler@opsdc.com
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Panic on OOM
In-Reply-To: <1308102282.2074.351.camel@compaq-desktop>
Message-ID: <alpine.DEB.2.00.1106141900001.7025@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop> <20110615094113.fa89be99.kamezawa.hiroyu@jp.fujitsu.com> <1308102282.2074.351.camel@compaq-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011, Chris Fowler wrote:

> Previous version is 2.6.33.
> 
> This box is a small device and I've configured it so that it on OOM or
> panic will reboot.  A device that is locked or out of memory is useless
> and if it reboots it will pick up where it left off.  This has worked
> well for me.
> 

Not sure why you're responding to Kame when you're really replying to my 
email.  The problem is not the oom killer, Chris says that the kernel 
reports that it will reboot in 10 seconds, because of his 
/proc/sys/kernel/panic setting, yet that never happens.  He is able to 
induce a panic easily with the oom killer, but the problem being reported 
here has nothing to do with the VM.

> -------- [ cpuinfo]----------------------------------------------------
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 28
> model name	: Intel(R) Atom(TM) CPU N270   @ 1.60GHz
> stepping	: 2
> cpu MHz		: 1600.245
> cache size	: 512 KB
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc up
> arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3
> xtpr pdcm movbe lahf_lm dts
> bogomips	: 3200.49
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 32 bits physical, 32 bits virtual
> power management:
> -------- [ cpuinfo]----------------------------------------------------
> 
> config attached
> 
> 
> I've not tried reboot=force.  I will do that next
> 

If that works, then we'll know that the forced machine restart is stalling 
or looping.  Using "reboot=force" supposedly will ensure that no such 
condition may ever exist for x86.  Do you know the last kernel version 
that actually worked correctly?

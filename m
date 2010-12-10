Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab0LJRTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:19:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23141 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0LJRTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:19:36 -0500
Date: Fri, 10 Dec 2010 09:18:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 22 (kvm)
Message-Id: <20101210091859.63a6a43e.randy.dunlap@oracle.com>
In-Reply-To: <4CF3EC1E.7050707@redhat.com>
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>
	<20101122132627.bd4e88ef.randy.dunlap@oracle.com>
	<20101129083324.6870d7da.randy.dunlap@oracle.com>
	<4CF3D637.6060204@redhat.com>
	<4CF3E733.8090809@redhat.com>
	<4CF3E870.4040308@oracle.com>
	<4CF3EC1E.7050707@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 08:08:30 -1000 Zachary Amsden wrote:

> On 11/29/2010 07:52 AM, Randy Dunlap wrote:
> > On 11/29/10 09:47, Zachary Amsden wrote:
> >    
> >> On 11/29/2010 06:35 AM, Avi Kivity wrote:
> >>      
> >>> On 11/29/2010 06:33 PM, Randy Dunlap wrote:
> >>>        
> >>>> On Mon, 22 Nov 2010 13:26:27 -0800 Randy Dunlap wrote:
> >>>>
> >>>>          
> >>>>>   On Mon, 22 Nov 2010 13:49:11 +1100 Stephen Rothwell wrote:
> >>>>>
> >>>>>            
> >>>>>>   Hi all,
> >>>>>>
> >>>>>>   Changes since 20101119:
> >>>>>>              
> >>>>>
> >>>>>   kvm.c:(.init.text+0x11f49): undefined reference to
> >>>>>            
> >>>> `kvm_register_clock'
> >>>>          
> >>>>>   when CONFIG_KVM_CLOCK is not enabled.
> >>>>>            
> >>>>
> >>>> BUild error still present in linux-next-2010-NOV-29.
> >>>>
> >>>>          
> >>> Glauber, Zach?
> >>>
> >>>        
> >> I can only speculate this reference is being called from smpboot without
> >> CONFIG guarding?
> >>      
> > Sorry, looks like I dropped the first line of the error messages:
> >
> > arch/x86/built-in.o: In function `kvm_smp_prepare_boot_cpu':
> > kvm.c:(.init.text+0xad38): undefined reference to `kvm_register_clock'
> >
> > from arch/x86/kernel/kvm.c:
> >
> > #ifdef CONFIG_SMP
> > static void __init kvm_smp_prepare_boot_cpu(void)
> > {
> > 	WARN_ON(kvm_register_clock("primary cpu clock"));
> > 	kvm_guest_cpu_init();
> > 	native_smp_prepare_boot_cpu();
> > }
> >
> > so it looks like you are correct...
> >    
> 
> Looks like this is the appropriate fix:
> 
> #ifdef CONFIG_SMP
> static void __init kvm_smp_prepare_boot_cpu(void)
> {
> #ifdef CONFIG_KVM_CLOCK
> 	WARN_ON(kvm_register_clock("primary cpu clock"));
> #endif
> 	kvm_guest_cpu_init();
> 	native_smp_prepare_boot_cpu();
> }


Can we get this fix merged, please?

Build error is still happening in linux-next 20101210.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

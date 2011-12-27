Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1L0JPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 04:15:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1L0JPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 04:15:45 -0500
Message-ID: <4EF98CB4.2050408@redhat.com>
Date: Tue, 27 Dec 2011 11:15:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <87vcp4t45p.fsf@linux.vnet.ibm.com> <4EF838BD.60406@redhat.com> <87d3bbtvnw.fsf@linux.vnet.ibm.com> <4EF85D50.8000204@redhat.com> <87aa6eu6o8.fsf@linux.vnet.ibm.com>
In-Reply-To: <87aa6eu6o8.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2011 03:47 AM, Nikunj A Dadhania wrote:
> On Mon, 26 Dec 2011 13:41:04 +0200, Avi Kivity <avi@redhat.com> wrote:
> > On 12/26/2011 01:33 PM, Nikunj A Dadhania wrote:
> > 
> > > I have enabled the following in my config;
> > >
> > > [root@krm1 linux-tip]# grep X2APIC .config
> > > CONFIG_X86_X2APIC=y
> > > [root@krm1 linux-tip]#
> > >
> > > And booted the kernel with "apic=verbose" command. 
> > >
> > > [root@krm1 linux-tip]# dmesg | grep -i x2apic
> > > [root@krm1 linux-tip]# 
> > >
> > > Does not give anything. I safely assumed that x2apic is not
> > > supported. Is there something to do in the bios to enable this?
> > 
> > Sorry, I was imprecise.  Boot the guest, it will recognize the emulated
> > x2apic.
> >
> I booted the guest with -cpu ...,+x2apic (using libvirt), and verified
> that qemu command-line does contain x2apic.
>
> There is a log saying this:
>
> Using CPU model
> "Nehalem,+rdtscp,+x2apic,+dca,+xtpr,+tm2,+est,+vmx,+ds_cpl,+monitor,+pbe,+tm,+ht,+ss,+acpi,+ds,+vme"
>  
> Though in the guest dmesg, I still do not see any x2apic logs. I am
> missing something obvious here. 
>

Check that X2APIC is enabled in the guest .config, as well as
CONFIG_KVM_GUEST.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1LZLhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:37:25 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44107 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1LZLhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:37:20 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EF838BD.60406@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <87vcp4t45p.fsf@linux.vnet.ibm.com> <4EF838BD.60406@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 26 Dec 2011 17:03:07 +0530
Message-ID: <87d3bbtvnw.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122601-9264-0000-0000-000000819653
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Dec 2011 11:05:01 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/26/2011 05:14 AM, Nikunj A Dadhania wrote:
> > > 
> > > btw you can get an additional speedup by enabling x2apic, for
> > > default_send_IPI_mask_logical().
> > > 
> > In the host?
> >
> 
> In the host, 
>
The machine(IBM x3650 M2, Nehalem) does not seem to support x2apic. 

I have enabled the following in my config;

[root@krm1 linux-tip]# grep X2APIC .config
CONFIG_X86_X2APIC=y
[root@krm1 linux-tip]#

And booted the kernel with "apic=verbose" command. 

[root@krm1 linux-tip]# dmesg | grep -i x2apic
[root@krm1 linux-tip]# 

Does not give anything. I safely assumed that x2apic is not
supported. Is there something to do in the bios to enable this?

> for the guest:
> 
>  qemu -cpu ...,+x2apic
> 
I need to try this, i have libvirt setup. Let me dig how to enable this
through xml file.

Regards
Nikunj


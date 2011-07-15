Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1GOOWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:22:16 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:48192 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1GOOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:22:15 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20110714180528.GF6672@redhat.com>
References: <1309944287.3937.39.camel@br98xy6r>
	 <20110707193321.GE28850@redhat.com> <20110708110121.5acfc3c9@mschwide>
	 <20110711144255.GE30674@redhat.com> <20110711175626.121dcc58@mschwide>
	 <20110713160239.GE4426@redhat.com> <20110713184611.6dcb09b4@mschwide>
	 <20110713200004.GG4426@redhat.com> <20110714091800.720da848@mschwide>
	 <20110714175532.GE6672@redhat.com>  <20110714180528.GF6672@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 15 Jul 2011 16:21:57 +0200
Message-ID: <1310739717.10789.31.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 14:05 -0400, Vivek Goyal wrote:
> On Thu, Jul 14, 2011 at 01:55:32PM -0400, Vivek Goyal wrote:
> 
> [..]
> > > > So we first try to take purgatory path which does the checksum and is
> > > > consistent with other architectures. If that does not work in case
> > > > of hard hang, you always have the option of IPLing the stand alone tool
> > > > later manually.
> > > 
> > > How are we suddenly on the purgatory path again? The code that gets
> > > control in case of a hard crash + IPL is the stand-alone dump tool,
> > > not the purgatory code.
> > 
> > I think that's the biggest contetion point. From the start of discussion
> > you have this hardcoded requirement that the moment panic() happens
> > you are jumping to some IPL code and that's what I am questioning. Why
> > can't you execute some more code after panic() (purgatory), before
> > you jump to IPL code (only if you have to). 
> > 
> 
> In your parlance of shutdown actions, I think it is equivalnet to saying
> that "kdump" is a shutdown action and that that means is that for specific
> trigger points we will execute "crash_kexec()" function which will try
> to capture the dump.
> 
> In user space I think one can modify the kexec-tools infrastrucuture a
> bit so that one is able to define an entry point in case checksum of
> loaded segment failes. Once you are loding kdump kernel, you can define
> that entry point. (And this would be jump to IPL etc.).

You mean to jump back into the crashed kernel code in case the kdump
checksum failed?

In the meantime I was looking a bit more into the kexec code to find
out, what we would have to do, if we use the preallocated ELF header as
you want us to do. With our actual solution, we do not have to reserve
any special areas for the kdump kernel. Now we have to reserve the ELF
header. So what are the options?

The x86 implementation uses a kernel parameter "memmap=exactmap" to do
that.

On ia64 - if I understood the code correctly - they seem to pass a kdump
segment "EFI_memmap" to the kdump kernel that contains information about
all loaded kexec segments. With this segment they can find out the size
of the ELF header segment in the kdump kernel and then do the memory
reservation at boot time. Is that correct?

Michael



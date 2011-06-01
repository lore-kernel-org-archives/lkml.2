Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab1FARlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:41:51 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:48664 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab1FARlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:41:49 -0400
Date: Wed, 1 Jun 2011 13:41:34 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: prasad@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
Message-ID: <292370127.12181.1306950094350.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110601172326.GA17449@redhat.com>
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal
 MCE, capture related information
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Wed, Jun 01, 2011 at 01:18:16PM -0400, Dave Anderson wrote:
> > FWIW, unlike mcelog, it really doesn't have to be maintained in the crash
> > utility. It's just another kernel data structure whose contents can be
> > determined dynamically during runtime:
> >
> 
> That's what I was wondering. Why can't we simple extract the contents
> of this structure from /proc/vmcore and save it, instead of trying to
> export it by appending additional elf notes to vmcore.

Actually I take that back -- Prasad's patch looks at the ELF header
contents and exits before the crash utility invokes the embedded gdb, 
so the structure contents are unavailable at that time.  It doesn't even 
use the vmlinux file.  

Dave 

> 
> Thanks
> Vivek
> 
> >   crash> struct mce
> >   struct mce {
> >       __u64 status;
> >       __u64 misc;
> >       __u64 addr;
> >       __u64 mcgstatus;
> >       __u64 ip;
> >       __u64 tsc;
> >       __u64 time;
> >       __u8 cpuvendor;
> >       __u8 inject_flags;
> >       __u16 pad;
> >       __u32 cpuid;
> >       __u8 cs;
> >       __u8 bank;
> >       __u8 cpu;
> >       __u8 finished;
> >       __u32 extcpu;
> >       __u32 socketid;
> >       __u32 apicid;
> >       __u64 mcgcap;
> >   }
> >   SIZE: 88
> >   crash>
> >
> > Dave
> >
> > > If you think that this complicates the patch, I'll start with a
> > > much
> > > 'slimmer' version (!) of the slimdump and the improvements may be
> > > contemplated iteratively.
> > >
> > > Thanks,
> > > K.Prasad

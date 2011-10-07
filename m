Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965498Ab1JGQiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:38:19 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35138 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760142Ab1JGQiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:38:17 -0400
Date: Fri, 7 Oct 2011 22:06:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111007163600.GB2297@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004150417.GA23604@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004150417.GA23604@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11100707-3568-0000-0000-0000007BFBBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 11:04:17AM -0400, Nick Bowler wrote:
> On 2011-10-03 13:02 +0530, K.Prasad wrote:
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > index 08363b0..483b2fc 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -238,6 +238,34 @@ static atomic_t mce_paniced;
> >  static int fake_panic;
> >  static atomic_t mce_fake_paniced;
> >  
> > +void arch_add_nocoredump_note(u32 *buf)
> > +{
> > +	struct elf_note note;
> > +	const char note_name[] = "PANIC_MCE";
> 
>         static const ...
> 
> > +	const char desc_msg[] = "Crash induced due to a fatal machine "
> > +				"check error";
> 
>         likewise.
> 

Not sure why you wanted them to be defined as static. These strings are
going to be copied into respective elf-note buffers just a few lines
below their definitions.

> Please don't break string literals onto multiple lines like this, since
> it prevents users from finding the string using "grep".

We could do so, hoping that checkpatch.pl doesn't complain if we crossed
the 80-column width :-)

Thanks,
K.Prasad


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1K2OiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:38:19 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:56351 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab1K2OiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:38:18 -0500
Date: Tue, 29 Nov 2011 20:07:52 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Dave Anderson <anderson@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 1/2][slimdump] Append CRASH_REASON to VMCOREINFO
 elf-note
Message-ID: <20111129143752.GA3804@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111123174225.GA5184@in.ibm.com>
 <b52b5e28-5805-4614-97cf-278610e2c574@zmail15.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b52b5e28-5805-4614-97cf-278610e2c574@zmail15.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11112914-1524-0000-0000-000000596181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 02:45:23PM -0500, Dave Anderson wrote:
> 
> 
> ----- Original Message -----
> > On Mon, Nov 21, 2011 at 10:19:31AM -0500, Dave Anderson wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > > > Allow various crash paths to append the reason of crash into the
> > > > VMCOREINFO elf-note through the field CRASH_REASON. We also make the
> > > > fatal machine check exceptions append "PANIC_MCE" as the crash
> > > > reason.  This string will be recognised by upstream tools like
> > > > makedumpfile and crash to generate slimdump.
> > > 
> > > I don't understand -- how could "various paths" append a reason?
> > > The patch below seems to return "PANIC_MCE" for every x86 crash.
> > > What am I missing?
> > > 
> > > Dave
> > >
> > 
> > Yes, presently it can only be "PANIC_MCE" for MCE crashes in x86 (not
> > for every crash though).
> 
> Why only MCE crashes?  If your arch/x86/kernel/cpu/mcheck/mce.c is 
> compiled into any x86 kernel, then its arch_add_crash_reason() will 
> always override the weak version in kernel/kexec.c, right? 
>

(Sorry for the delayed reply...there was a multiple-day outage in my
email server).

Yes, I think it should be better by using a variable to allow
various crash paths of each architecture populate the reason (the
function approach doesn't work, we can use a function pointer
that just returns a pointer to a char array, but that's less
preferable and convoluted).

I'll change the code to contain a char pointer in a generic file, say
arch/x86/kernel/crash.c which will be populated by the MCE crash path.
The code in kernel/kexec.c can just use this.

Thanks for your comments.

--K.Prasad
 


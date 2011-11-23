Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1KWTpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:45:41 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:44282 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab1KWTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:45:40 -0500
Date: Wed, 23 Nov 2011 14:45:23 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: prasad@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 1/2][slimdump] Append CRASH_REASON to VMCOREINFO elf-note
Message-ID: <b52b5e28-5805-4614-97cf-278610e2c574@zmail15.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20111123174225.GA5184@in.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.16.19.41]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Mon, Nov 21, 2011 at 10:19:31AM -0500, Dave Anderson wrote:
> > 
> > 
> > ----- Original Message -----
> > > Allow various crash paths to append the reason of crash into the
> > > VMCOREINFO elf-note through the field CRASH_REASON. We also make the
> > > fatal machine check exceptions append "PANIC_MCE" as the crash
> > > reason.  This string will be recognised by upstream tools like
> > > makedumpfile and crash to generate slimdump.
> > 
> > I don't understand -- how could "various paths" append a reason?
> > The patch below seems to return "PANIC_MCE" for every x86 crash.
> > What am I missing?
> > 
> > Dave
> >
> 
> Yes, presently it can only be "PANIC_MCE" for MCE crashes in x86 (not
> for every crash though).

Why only MCE crashes?  If your arch/x86/kernel/cpu/mcheck/mce.c is 
compiled into any x86 kernel, then its arch_add_crash_reason() will 
always override the weak version in kernel/kexec.c, right? 

Dave
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1KWQOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:14:41 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51200 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1KWQOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:14:39 -0500
Date: Wed, 23 Nov 2011 21:44:17 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [RFC Patch 1/2][slimdump] Append CRASH_REASON to VMCOREINFO
 elf-note
Message-ID: <20111123161417.GA2515@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111121095405.GA2289@in.ibm.com>
 <20111121101157.GA10194@in.ibm.com>
 <20111121151157.GE313@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121151157.GE313@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11112316-3864-0000-0000-00000036D5FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:11:57AM -0500, Vivek Goyal wrote:
> On Mon, Nov 21, 2011 at 03:41:57PM +0530, K.Prasad wrote:
> > Allow various crash paths to append the reason of crash into the
> > VMCOREINFO elf-note through the field CRASH_REASON. We also make the
> > fatal machine check exceptions append "PANIC_MCE" as the crash reason.
> > This string will be recognised by upstream tools like makedumpfile and
> > crash to generate slimdump.
> > 
> > With increased usage of the CRASH_REASON field, the crash strings can be
> > encoded for better usage.
> > 

[snipped]

> > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > index dc7bc08..a731693 100644
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -1080,6 +1080,11 @@ asmlinkage long compat_sys_kexec_load(unsigned long entry,
> >  }
> >  #endif
> >  
> > +__weak char *arch_add_crash_reason(void)
> > +{
> > +	return (char *)NULL;
> > +}
> > +
> >  void crash_kexec(struct pt_regs *regs)
> >  {
> >  	/* Take the kexec_mutex here to prevent sys_kexec_load
> > @@ -1411,6 +1416,7 @@ static void update_vmcoreinfo_note(void)
> >  void crash_save_vmcoreinfo(void)
> >  {
> >  	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
> > +	vmcoreinfo_append_str("\nCRASH_REASON=%s\n", arch_add_crash_reason());
> 
> I think don't even create a CRASH_REASON= entry if arch returns a NULL
> string.
>

Yes, we could do that. I'll change the code accordingly in the next
revision of the patchset.

Thanks,
K.Prasad
 


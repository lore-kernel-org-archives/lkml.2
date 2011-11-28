Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab1K1OYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:24:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab1K1OYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:24:40 -0500
Date: Mon, 28 Nov 2011 09:24:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [RFC Patch 0/2] Slimdump framework using CRASH_REASON - v2
Message-ID: <20111128142402.GA20758@redhat.com>
References: <20111121095405.GA2289@in.ibm.com>
 <20111121151727.GF313@redhat.com>
 <20111123173318.GB2515@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123173318.GB2515@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:03:18PM +0530, K.Prasad wrote:
> On Mon, Nov 21, 2011 at 10:17:27AM -0500, Vivek Goyal wrote:
> > On Mon, Nov 21, 2011 at 03:24:05PM +0530, K.Prasad wrote:
> > > Hi All,
> > > 	In furtherance of the previous discussion regarding 'slimdump'
> > > (refer: http://article.gmane.org/gmane.linux.kernel/1204967), it was
> > > decided that,
> > > 
> > > - An entry in VMCOREINFO elf-note be added to denote the cause of crash,
> > >   instead of creating a new elf-note.
> > > 
> > > - Upstream tools such as 'makedumpfile' and 'crash' be modified to
> > >   recognise this string and inform the user accordingly.
> > > 
> > > Accordingly, this new version of the patchset makes the following
> > > changes 
> > > 
> > > Changelog - version 2
> > > -----------------------
> > > (First version posted here:
> > > http://article.gmane.org/gmane.linux.kernel/1198435)
> > > 
> > > - Append VMCOREINFO elf-note with a new variable CRASH_REASON whose
> > >   value will be populated using arch_add_crash_reason() function.
> > > 
> > > - Define arch_add_crash_reason() in the x86 MCE path to return "PANIC_MCE"
> > >   in the panic path of MCE.
> > > 
> > > - 'makedumpfile' tool is taught to recognise PANIC_MCE string as one
> > >   value of CRASH_REASON for which 'slimdump' must be captured.
> > 
> > So again, what is slimdump? I mean, what information is now being captured
> > in the case of slimdump? Are you capturing atleast the kernel message
> > buffers? I am assuming that any register info emitted on console will
> > make into kernel buffers and that should be useful to figure out what
> > MCE happened.
> > 
> 
> The kernel message buffers can be obtained by using the --dump-dmesg
> option of makedumpfile but again that's risky. We wouldn't know if it'll
> cause access to the faulty memory (which is how the previous method of having
> a new elf-notes in a pristine location is much safer).
> 
> The method in this patch is quite primitive in that informs the user
> nothing more than a one-line cause of crash. One should take help from other
> tools (such as service processor/firmware/ACPI logs, or previous corrected
> error logs) to infer the location of bad memory.

And how does one get to firmware/ACPI logs? Many system don't have service
processor also.

I think extracting kernel buffers by default in case of MCE is reasonable.
This should allow somebody to figure out some MCE related information.

You might want to modify makedumpfile so that it does not try to access
pages marked poisoned.

Thanks
Vivek

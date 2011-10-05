Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934941Ab1JEQQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:16:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51903 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934476Ab1JEQQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:16:30 -0400
Date: Wed, 5 Oct 2011 18:16:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Valdis.Kletnieks@vt.edu
Cc: Vivek Goyal <vgoyal@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005161626.GB18592@gere.osrc.amd.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <m162k64c7w.fsf@fess.ebiederm.org>
 <20111003120336.GK2223@in.ibm.com>
 <20111004063440.GB5723@liondog.tnic>
 <20111005070728.GA2235@in.ibm.com>
 <20111005073111.GA13478@liondog.tnic>
 <20111005094727.GB7485@in.ibm.com>
 <20111005155217.GE30146@redhat.com>
 <10327.1317830438@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10327.1317830438@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 12:00:38PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 05 Oct 2011 11:52:17 EDT, Vivek Goyal said:
> 
> > I am assuming that basic MCE error messages are available in kernel log. 
> 
> They're not in the kernel log if it's an MCE that causes the kernel to declare
> a panic. There's some MCE's that you can retry the operation and continue, and
> some that you can get away with poisoning a page, killing the process, and rest
> of the system is OK.  But some you really need to roll over and die because you
> can't guarantee kernel integrity anymore.
> 
> And at that point, those messages are never gonna make it to syslogd and onto
> disk.

AFAICT, and for the sake of getting the MCE info, arguably one could
look for log_buf in the vmcore of the old kernel and try to find the
last lines in the kernel log ringbuffer. They should be the MCE error
information from the do_machine_check MCE handler.

This all assuming of course we've managed to dump vmcore successfully by
sidestepping the landmines :-).

-- 
Regards/Gruss,
Boris.

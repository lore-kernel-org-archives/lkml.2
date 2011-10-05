Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639Ab1JEMlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:41:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41800 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934359Ab1JEMlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:41:17 -0400
Date: Wed, 5 Oct 2011 14:41:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        crash-utility@redhat.com, kexec@lists.infradead.org,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005124113.GB509@gere.osrc.amd.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <m162k64c7w.fsf@fess.ebiederm.org>
 <20111003120336.GK2223@in.ibm.com>
 <20111004063440.GB5723@liondog.tnic>
 <20111005070728.GA2235@in.ibm.com>
 <20111005073111.GA13478@liondog.tnic>
 <20111005094727.GB7485@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005094727.GB7485@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 03:17:27PM +0530, K.Prasad wrote:
> We don't want to capture memory dump when the machine crashes due to
> faulty cache, because the end-user derives no benefit by receiving a
> bulky vmcore and running crash analysis tools over them. Instead a
> 'slimdump' that contains a meaningful message about the origin of crash
> (and which can be understood by his analysis tools) would be better, or
> so I thought.

Ok, this makes sense, a meaningful message along with the MCE decoded
properly in userfriendly language so that one can understand why the
system has not captured vmcore.

> There are possibly several hardware errors which cause system crash and
> the kdump would capture full vmcore, although it doesn't make sense (I
> wouldn't have cared about the second example, you cited, if they did not
> generate MCE, but a different exception). In an ideal situation, each of
> these error paths would 'subscribe' to slimdump and add a meaningful
> message in the NT_NOCOREDUMP note instead of letting the user-space copy
> the old kernel memory.

Yep, I see.

> Fine with me. I see that the various IA32_MCi_Status registers will hold
> information about the error and use that to classify MCEs.
> 
> I think the best way to go about is to retain NT_NOCOREDUMP for non-DRAM
> errors also, but use the note-name field in the elf-note and distinguish the
> various types of errors...say, by using names such as "PANIC_MCE_DRAM",
> "PANIC_MCE_CACHE", etc (similar to the error codes described in the Intel
> manual). The upstream tools like 'makedumpfile' and 'crash' will have to
> be taught to parse the elf-note name and act accordingly.

Right, so Valdis had the right question in the other mail, let me
generalize it here: does it ever make sense to save vmcore on a hardware
error?

With DRAM errors, you probably could use the additional info coming with
the MCE do decode to the physical address and map back to the DIMM and
swap it. Any other use cases?

Thanks.

-- 
Regards/Gruss,
Boris.

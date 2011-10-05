Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895Ab1JEPxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934837Ab1JEPxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:53:23 -0400
Date: Wed, 5 Oct 2011 11:52:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005155217.GE30146@redhat.com>
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

[..]
> Fine with me. I see that the various IA32_MCi_Status registers will hold
> information about the error and use that to classify MCEs.
> 
> I think the best way to go about is to retain NT_NOCOREDUMP for non-DRAM
> errors also, but use the note-name field in the elf-note and distinguish the
> various types of errors...say, by using names such as "PANIC_MCE_DRAM",
> "PANIC_MCE_CACHE", etc (similar to the error codes described in the Intel
> manual). The upstream tools like 'makedumpfile' and 'crash' will have to
> be taught to parse the elf-note name and act accordingly.

I am assuming that basic MCE error messages are available in kernel log. 
Why can't user space simply scan the logs for MCE error and just save
the log buffers in case of MCE. That way a user gets the MCE information
while not trying to save the whole dump. And no need of an extra ELF note.

Thanks
Vivek

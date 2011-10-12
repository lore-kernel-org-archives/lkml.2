Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1JLQAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:00:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab1JLQAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:00:38 -0400
Date: Wed, 12 Oct 2011 11:59:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        crash-utility@redhat.com, kexec@lists.infradead.org,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111012155902.GD12845@redhat.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004140437.GA28306@redhat.com>
 <20111005071844.GB2235@in.ibm.com>
 <20111005152537.GB30146@redhat.com>
 <20111007161218.GA2297@in.ibm.com>
 <20111010070725.GB11577@liondog.tnic>
 <20111011184434.GB32316@in.ibm.com>
 <20111012104429.GA11983@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012104429.GA11983@gere.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 12:44:29PM +0200, Borislav Petkov wrote:

[..]
> > > But, regardless, according to Vivek, the "makedumpfile" tool should be
> > > able to jump over poisoned pages and you don't need all the hoopla above
> > > at all, right?
> > >
> > 
> > In short, the answer is yes. We could add a new string, say
> > "CRASH_REASON=PANIC_MCE" to VMCOREINFO elf-note which can be parsed by
> > 'makedumpfile' and get away without adding the new NT_NOCOREDUMP
> > elf-note. Parsing through the log_buf to lookout for panic string from
> > inside 'makedumpfile' appears to be a clumsy solution though.
> 
> Why, 'makedumpfile' reportedly supports some dmesg parsing already -
> why would you need additional functionality when it can be done with
> in-house means already. Maybe Vivek should comment on whether this makes
> sense but I'm basically reiterating what he said.

makdumpfile can extarct kernel log buf but it does not parse it. So it
just extracts the logs and one can save it to a file and parsing it
is left to user.

So exporting one more string through VMCOREINFO to signal that PANIC_MCE
happened makes sense to me. Rest of it can go into makedumpfile.

Thanks
Vivek

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952Ab1JEQZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:25:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57180 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934476Ab1JEQZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:25:23 -0400
Date: Wed, 5 Oct 2011 18:25:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "crash-utility@redhat.com" <crash-utility@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "tachibana@mxm.nes.nec.co.jp" <tachibana@mxm.nes.nec.co.jp>,
        "oomichi@mxs.nes.nec.co.jp" <oomichi@mxs.nes.nec.co.jp>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005162520.GC18592@gere.osrc.amd.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004143012.GB28306@redhat.com>
 <20111005074116.GC2235@in.ibm.com>
 <20111005154011.GD30146@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE62D58D@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EE62D58D@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 08:58:53AM -0700, Luck, Tony wrote:
> > > The plan is to pass-down the list of poisoned memory pages to the second
> > > kernel using an elf-note so that these pages are left untouched during
> > > dump capture. I'm working on an implementation of the same and should
> > > have patches soon.
> >
> > I would say let us first figure out what happens while reading a poisoned
> > page and is this a problem before working on a solution.
> 
> If the page is poisoned because of a real uncorrectable error in memory
> (reported as SRAO machine check today, or by SRAR real-soon-now). Then
> accessing the page from the processor while taking a memory dump will
> result in a machine check.
> 
> Note that a large memory system that had been running for a long time
> may have built up a small stash of these land-mine pages - and we need
> to worry about them even in the case where the panic is not machine
> check related (in fact especially in this case ... we are in a case
> where we actually do want the dump to diagnose the cause of the panic,
> and we don't want to risk losing the crash dump because we aborted when
> touching a page that the OS had safely avoided for days/weeks/months).
> 
> So passing a list of poisoned pages from the old kernel to the new kernel
> is a good idea - and is independent of the cause of the crash (except that
> in the fatal machine check case due to memory error the list is guaranteed
> to be non-empty).
> 
> Passing some crash signature data - so the new kernel/dump-tools can make
> a choice whether to even try to take a full dump is also interesting (but
> independent from the bad page list).

Good point,

this would probably advocate for the solution of disabling of detection
of at least certain MCEs like DRAM UCs and then, even if you manage
to dump core successfully, how can you be sure that the memory image
doesn't contain some corrupted data? So yes, some sort of error
and corresponding address collection is needed for later image
"preparation".

Hmm, this just got interesting.

-- 
Regards/Gruss,
Boris.

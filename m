Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934865Ab1JEPkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934801Ab1JEPke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:40:34 -0400
Date: Wed, 5 Oct 2011 11:40:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005154011.GD30146@redhat.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004143012.GB28306@redhat.com>
 <20111005074116.GC2235@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005074116.GC2235@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 01:11:16PM +0530, K.Prasad wrote:

[..]
> > Again, note_name and desc_msg seem to be only two exports. Frankly desc
> > string seems pretty obivious and we should be able to ignore it. So just
> > exporting PANIC_MCE=true or something like that in case of MCE. 
> >
> 
> Yes, adding a new field to the VMCOREINFO note would have been much
> simpler but there's a second part to the kdump + fatal MCE problem which
> will need a new elf-note to solve.
> 
> On a system containing 'poisoned' pages (generated as a result of
> detecting UC errors which haven't been 'consumed'), if a software bug results
> in crashing the machine, the ensuing kdump operation will read from the
> faulty memory location. This will trigger a new crash within the context
> of the kexec'ed kernel and we want to avoid this.

I think in other mail you mentioned that it is not known what happens
if we try to read pages marked as "poisoned".

> 
> The plan is to pass-down the list of poisoned memory pages to the second
> kernel using an elf-note so that these pages are left untouched during
> dump capture. I'm working on an implementation of the same and should
> have patches soon.

I would say let us first figure out what happens while reading a poisoned
page and is this a problem before working on a solution.

Thanks
Vivek

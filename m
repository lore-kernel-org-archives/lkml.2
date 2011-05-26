Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab1EZS1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:27:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1EZS1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:27:09 -0400
Date: Thu, 26 May 2011 14:26:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE
 generated crashes
Message-ID: <20110526182618.GD29496@redhat.com>
References: <20110526170722.GB23266@in.ibm.com>
 <20110526172305.GA18295@in.ibm.com>
 <20110526174447.GC29496@redhat.com>
 <20110526180931.GF4065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526180931.GF4065@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:09:31PM +0200, Andi Kleen wrote:
> On Thu, May 26, 2011 at 01:44:47PM -0400, Vivek Goyal wrote:
> > On Thu, May 26, 2011 at 10:53:05PM +0530, K.Prasad wrote:
> > > 
> > > slimdump: Capture slimdump for fatal MCE generated crashes
> > > 
> > > System crashes resulting from fatal hardware errors (such as MCE) don't need
> > > all the contents from crashing-kernel's memory. Generate a new 'slimdump' that
> > > retains only essential information while discarding the old memory.
> > > 
> > 
> > Why to enforce zeroing out of rest of the vmcore data in kernel. Why not
> > leave it to user space. 
> 
> I think it's a good default to not do a full dump on MCE.
> It's very unlikely to be useful for anything, and will just waste
> reboot time (aka nines).

If we are just extracting and saving MCE registers from vmcore, then
reboot time does not increase. It increases only if user decides to
extract and save extra data from vmcore.

> 
> That said including the dmesg too may be a good idea.

dmesg is already part of vmcore and user space tools can easily find
it. 

I can easily imagine a default policy of a distro in user space where
in case of MCE crash, we just extract dmesg and MCE registers (from vmcore
notes section) reboot. This will be fast and will reduce the amount of code
in kernel.

IMHO, we should not introduce any additional notion of slimdump as such in
kernel. A better thing would be to just read MCE registers and export to
user space through ELF notes and then let user space automate the rest of
it.

Thanks
Vivek

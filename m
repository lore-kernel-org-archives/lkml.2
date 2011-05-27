Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1E0PyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:54:13 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:58567 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1E0PyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:54:08 -0400
Date: Fri, 27 May 2011 21:23:46 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE
 generated crashes
Message-ID: <20110527155346.GA2384@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
 <20110526172305.GA18295@in.ibm.com>
 <20110526173257.GC4065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526173257.GC4065@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 07:32:57PM +0200, Andi Kleen wrote:
> On Thu, May 26, 2011 at 10:53:05PM +0530, K.Prasad wrote:
> > 
> > slimdump: Capture slimdump for fatal MCE generated crashes
> > 
> > System crashes resulting from fatal hardware errors (such as MCE) don't need
> > all the contents from crashing-kernel's memory. Generate a new 'slimdump' that
> > retains only essential information while discarding the old memory.
> 
> While this is a good idea, note there may be still poisoned lines
> in memory that haven't resulted in a machine check yet, but could
> still be fatal when read after a full crash dump for some other
> reason.
>

True, this patch does not handle the discovery of old poisoned lines/new
memory errors that may occur when inside the kdump kernel.
 
> So you still need 
> 
> http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=commit;h=fe61906edce9e70d02481a77a617ba1397573dce
> and
> http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=commit;h=cb58f049ae6709ddbab71be199390dc6852018cd
> 
> in addition.
> 
> -Andi

So, there could be (atleast) two ways to handle fatal MCEs in kdump
kernel:

- To disable MCE exceptions as done by the patches cited above. However
  the result of a read operation on corrupted memory is unknown and the
  system behaviour is undefined. We're unsure if this is a safe thing to
  do.

- To disable capture of kdump (when panic is invoked from) inside kdump
  kernel and simply reboot the system. Since the chance of memory error
  inside kdump kernel (which runs for a very short duration) is rare, I
  think this solution is preferrable.

Let me know your thoughts on this.

Thanks,
K.Prasad



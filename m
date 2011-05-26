Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab1EZTL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:11:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281Ab1EZTL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:11:58 -0400
Date: Thu, 26 May 2011 15:10:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE
 generated crashes
Message-ID: <20110526191008.GF29496@redhat.com>
References: <20110526170722.GB23266@in.ibm.com>
 <20110526172305.GA18295@in.ibm.com>
 <20110526174447.GC29496@redhat.com>
 <20110526180931.GF4065@one.firstfloor.org>
 <20110526182618.GD29496@redhat.com>
 <20110526185838.GG4065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526185838.GG4065@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:58:38PM +0200, Andi Kleen wrote:
> > If we are just extracting and saving MCE registers from vmcore, then
> > reboot time does not increase. It increases only if user decides to
> > extract and save extra data from vmcore.
> 
> Hmm I was thinking of user space usually saving the dump first
> before analyzing it. But yes it could probably do some minimal
> analysis first.

In RHEL, now we filter out the dump by default until and unless user
decides to no filter the dump with the help of config options. 

So I think in this case we can just introduce an extra filtering
option in "makedumpfile" and ask it to save only MCE registers
if it notices that there is NT_MCE type of ELF note in vmcore.

I can very well imaging that extracting dmesg along with MCE registers
can be useful. If nothing else, it can give us useful information about
the system configuration.

Zeroing out all the other ELF headers in vmcore takes away the
capability to extract log buffers in case of MCE and I think
it probably is not the best idea.

Thanks
Vivek

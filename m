Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab1EZSJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:09:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35666 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143Ab1EZSJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:09:32 -0400
Date: Thu, 26 May 2011 20:09:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE generated crashes
Message-ID: <20110526180931.GF4065@one.firstfloor.org>
References: <20110526170722.GB23266@in.ibm.com> <20110526172305.GA18295@in.ibm.com> <20110526174447.GC29496@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526174447.GC29496@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 01:44:47PM -0400, Vivek Goyal wrote:
> On Thu, May 26, 2011 at 10:53:05PM +0530, K.Prasad wrote:
> > 
> > slimdump: Capture slimdump for fatal MCE generated crashes
> > 
> > System crashes resulting from fatal hardware errors (such as MCE) don't need
> > all the contents from crashing-kernel's memory. Generate a new 'slimdump' that
> > retains only essential information while discarding the old memory.
> > 
> 
> Why to enforce zeroing out of rest of the vmcore data in kernel. Why not
> leave it to user space. 

I think it's a good default to not do a full dump on MCE.
It's very unlikely to be useful for anything, and will just waste
reboot time (aka nines).

That said including the dmesg too may be a good idea.

On the other hand I think the slim dump should be probably generalized
and used for more situations. I could well imagine enabling it by
default on various systems.
 
-Andi


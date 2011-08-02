Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1HBTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab1HBTQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:16:19 -0400
Date: Tue, 2 Aug 2011 15:16:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v2 01/10] kdump: Add KEXEC_CRASH_CONTROL_MEMORY_LIMIT
Message-ID: <20110802191603.GI6399@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
 <20110727125807.529303146@linux.vnet.ibm.com>
 <20110801201644.GG3805@redhat.com>
 <1312278664.4881.35.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312278664.4881.35.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 11:51:04AM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> On Mon, 2011-08-01 at 16:16 -0400, Vivek Goyal wrote:
> > On Wed, Jul 27, 2011 at 02:55:05PM +0200, Michael Holzheu wrote:
> > > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > > 
> > > On s390 there is a different KEXEC_CONTROL_MEMORY_LIMIT for the normal and
> > > the kdump kexec case. Therefore this patch introduces a new macro
> > > KEXEC_CRASH_CONTROL_MEMORY_LIMIT. This is set to
> > > KEXEC_CONTROL_MEMORY_LIMIT for all architectures that do not define
> > > KEXEC_CRASH_CONTROL_MEMORY_LIMIT.
> > 
> > Hi Michael,
> > 
> > Curious that why limit is different for kexec and kdump cases on s390
> > only.
> 
> The standard kexec relocate_kernel code calls a machine instruction that
> must run below 2 GiB. For kdump we currently do not use the control page
> at all because no segments have to be moved in that case. Perhaps I am
> still missing something here?

On x86, control page is used for transition to purgatory and second kernel
and common code is used. The only step which is skipped in case of kdump
is the page copying part. As code is common for both the cases the limit
is same.

If you are not using control page at all during s390 kdump (because you
are doing all the setup in dump tools, then probably you can specify
a higher limit so control page.) So in this case you are allocating
control page but not using it?

Thanks
Vivek

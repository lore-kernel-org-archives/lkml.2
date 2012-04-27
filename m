Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897Ab2D0R1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:27:08 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:43901 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760638Ab2D0R1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:27:05 -0400
Date: Fri, 27 Apr 2012 10:27:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] percpu, x86: don't use PMD_SIZE as embedded atom_size
 on 32bit
Message-ID: <20120427172701.GC26595@google.com>
References: <4F97BA98.6010001@intel.com>
 <20120425222429.GE8989@google.com>
 <1335405672.14538.135.camel@ymzhang.sh.intel.com>
 <20120426224946.GG27486@google.com>
 <1335488964.14538.159.camel@ymzhang.sh.intel.com>
 <1335516994.14538.160.camel@ymzhang.sh.intel.com>
 <20120427165356.GA26595@google.com>
 <alpine.DEB.2.00.1204271219320.32270@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204271219320.32270@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:21:34PM -0500, Christoph Lameter wrote:
> On Fri, 27 Apr 2012, Tejun Heo wrote:
> 
> > This patch makes x86_32 always use PAGE_SIZE as atom_size for embed
> > first chunk allocator.
> 
> Would it not be easier to use the first #ifdef in the function to set
> pcpu_chosen_fc = PCPU_FC_PAGE?
> 
> You could just skip the whole PCPU_FC_PAGE block in the CONFIG_X86_32
> case.

PCPU_FC_PAGE != PCPU_FC_EMBED w/ PAGE_SIZE atom_size.  EMBED still
gets to piggy back on the kernel linear mapping for the first chunk
unlike PAGE.  It apparently created noticeable difference (I'm
guessing due to extra TLB pressure) for intel android folks.

Thanks.

-- 
tejun

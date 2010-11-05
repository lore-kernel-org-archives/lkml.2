Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0KERRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:17:15 -0400
Received: from amber.ccs.neu.edu ([129.10.116.51]:52567 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0KERRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:17:14 -0400
Date: Fri, 5 Nov 2010 13:17:03 -0400
From: Gene Cooperman <gene@ccs.neu.edu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Kapil Arya <kapil@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101105171703.GA1760@sundance.ccs.neu.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <4CD23087.30900@cs.columbia.edu>
 <AANLkTikgPKeZUih6_12JWSNy=Vsz2UP9HR7wHOz4q6ST@mail.gmail.com>
 <987664A83D2D224EAE907B061CE93D53016485FE6E@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D53016485FE6E@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 04:57:33AM -0700, Luck, Tony wrote:
> > Oren noted that sometimes it's important to stop the process only
> > for a few milliseconds while one checkpoints. In DMTCP, we do that
> > by configuring with --enable-forked-checkpointing. This causes us
> > to fork a child process taking advantage of copy-on-write and then
> > checkpoint the memory pages of the child while the parent continues
> > to execute.
> 
> Interesting ... but while the process is only stopped for the duration
> of the fork, it may be taking COW faults on almost every page it
> touches.  I think this will not work well for large HPC applications
> that allocate most of physical memory as anonymous pages for the
> application. It may even result in an OOM kill if you don't complete
> the checkpoint of the child and have it exit in a timely manner.
> 
> -Tony
> 

I agree with you that forked checkpointing is probably not what you
want in the middle of an HPC computation.  But isn't that part of
the nature of COW?  Whether the COW is invoked within the kernel,
or from outside the kernel via fork --- in either case, when you have
mostly dirty pages, you will have to copy most of the pages.
Do I understand your point correctly?			Thanks,
							- Gene

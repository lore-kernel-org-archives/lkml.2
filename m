Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1JGShL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:37:11 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:54180 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642Ab1JGShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:37:08 -0400
Date: Fri, 7 Oct 2011 14:19:06 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111007181906.GA13172@elliptictech.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004150417.GA23604@elliptictech.com>
 <20111007163600.GB2297@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007163600.GB2297@in.ibm.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-07 22:06 +0530, K.Prasad wrote:
> On Tue, Oct 04, 2011 at 11:04:17AM -0400, Nick Bowler wrote:
> > On 2011-10-03 13:02 +0530, K.Prasad wrote:
> > > +	const char note_name[] = "PANIC_MCE";
> > 
> >         static const ...
> > 
> > > +	const char desc_msg[] = "Crash induced due to a fatal machine "
> > > +				"check error";
> > 
> >         likewise.
> 
> Not sure why you wanted them to be defined as static. These strings are
> going to be copied into respective elf-note buffers just a few lines
> below their definitions.

It's possible that GCC's optimizer will do the right thing in either
case and it won't matter at all.  I haven't tried compiling this patch
so I've not looked at the compiler output.  But for the most part, using
"static" will save the few bytes of code needed to copy these strings
onto the stack (as well as the corresponding reduction in stack usage).

> > Please don't break string literals onto multiple lines like this, since
> > it prevents users from finding the string using "grep".
> 
> We could do so, hoping that checkpatch.pl doesn't complain if we crossed
> the 80-column width :-)

If it does, the error is in checkpatch.pl rather than your code. :)

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

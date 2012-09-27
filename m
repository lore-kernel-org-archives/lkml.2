Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab2I0EMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:12:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34474 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2I0EMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:12:39 -0400
Date: Thu, 27 Sep 2012 06:12:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tao Guo <glorioustao@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        stable@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86_64: Work around old gas bug
Message-ID: <20120927041233.GA3013@gmail.com>
References: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
 <20120926132549.GA23630@kroah.com>
 <CAAV8rnK_+g7jFZ-_V4VG-e4FGWqevkA-mJvy=d3ivmoEWnUo1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAV8rnK_+g7jFZ-_V4VG-e4FGWqevkA-mJvy=d3ivmoEWnUo1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tao Guo <glorioustao@gmail.com> wrote:

> On Wed, Sep 26, 2012 at 9:25 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Sep 26, 2012 at 04:28:22AM -0400, Tao Guo wrote:
> >> gas in binutils(2.16.91) could not parse parentheses within macro
> >> parameters unless fully parenthesized, and this is a workaround to
> >> make old gas work without generating below errors:
> >> arch/x86/kernel/entry_64.S: Assembler messages:
> >> arch/x86/kernel/entry_64.S:387: Error: too many positional arguments
> >> arch/x86/kernel/entry_64.S:389: Error: too many positional arguments
> >> arch/x86/kernel/entry_64.S:390: Error: too many positional arguments
> >> arch/x86/kernel/entry_64.S:391: Error: too many positional arguments
> >> arch/x86/kernel/entry_64.S:392: Error: too many positional arguments
> >> arch/x86/kernel/entry_64.S:393: Error: too many positional arguments
> >> arch/x86/kernel/entry_64.S:394: Error: too many positional arguments
> >>
> >> Signed-off-by: Tao Guo <glorioustao@gmail.com>
> >> ---
> >>  arch/x86/include/asm/calling.h |   48 +++++++++++++++++++--------------------
> >>  arch/x86/kernel/entry_64.S     |   20 ++++++++--------
> >>  2 files changed, 33 insertions(+), 35 deletions(-)
> >
> > <formletter>
> >
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> >
> > </formletter>
> 
> Thanks Greg, I just realized that I followed the old rules in 
> an old Documentation/stable_kernel_rules.txt file. Since the 
> patches for other stable branches will be a little different 
> from this one, I will send them later to 
> stable@vger.kernel.org after this patch gets accepted.

Please don't send this to -stale yet (or at all).

I have queued up the patch for v3.7, not even for v3.6. It needs 
more testing - old GAS users are probably better off having a 
non-building kernel than a subtly broken one. v3.7 and onwards 
stable kernels will have the fix - hopefully by the time it's 
released any more subtle bugs are found and fixed.

Thanks,

	Ingo

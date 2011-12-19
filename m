Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1LSKOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:14:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1LSKNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:13:54 -0500
Date: Mon, 19 Dec 2011 10:13:51 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl misreporting bugs with array fillings
Message-ID: <20111219101351.GE2830@shadowen.org>
References: <201112162259.29043.marek.vasut@gmail.com>
 <CAAq6er31hkB++ROFdA0OxCEn9LBEW_StVa+CvMrzkKnCJayF_w@mail.gmail.com>
 <201112162331.06505.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112162331.06505.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 11:31:06PM +0100, Marek Vasut wrote:
> > On Fri, Dec 16, 2011 at 9:59 PM, Marek Vasut <marek.vasut@gmail.com> wrote:
> > > Hi,
> > > 
> > > the following testcase is probably misreported by checkpatch.pl:
> > > 
> > > static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
> > >        {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> > >        {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> > > };
> > > 
> > > The result is:
> > > 
> > > ERROR: space prohibited before open square bracket '['
> > > #2: FILE: testcase.c:2:
> > > +       {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> > > 
> > > ERROR: space prohibited before open square bracket '['
> > > #3: FILE: testcase.c:3:
> > > +       {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> > > 
> > > total: 2 errors, 0 warnings, 5 lines checked
> > > 
> > > NOTE: Ignored message types: COMPLEX_MACRO CONSIDER_KSTRTO MINMAX
> > > MULTISTATEMENT_MACRO_USE_DO_WHILE
> > > 
> > > testcase.c has style problems, please review.
> > 
> > Hmmm will have a look...
> 
> Thanks! I'd send a patch, but I'm now doing checkpatch cleanup of uboot sources 
> so I'm just submitting a testcase and delegating the issue.

Ok, this one may well be simple to fix.  Does the version of checkpatch
below work ok for you:

  http://people.canonical.com/~apw/checkpatch/checkpatch-next.pl

-apw

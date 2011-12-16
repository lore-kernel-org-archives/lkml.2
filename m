Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917Ab1LPWbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:31:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33216 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1LPWbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:31:09 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: checkpatch.pl misreporting bugs with array fillings
Date: Fri, 16 Dec 2011 23:31:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: joe@perches.com, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
References: <201112162259.29043.marek.vasut@gmail.com> <CAAq6er31hkB++ROFdA0OxCEn9LBEW_StVa+CvMrzkKnCJayF_w@mail.gmail.com>
In-Reply-To: <CAAq6er31hkB++ROFdA0OxCEn9LBEW_StVa+CvMrzkKnCJayF_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112162331.06505.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Dec 16, 2011 at 9:59 PM, Marek Vasut <marek.vasut@gmail.com> wrote:
> > Hi,
> > 
> > the following testcase is probably misreported by checkpatch.pl:
> > 
> > static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
> >        {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> >        {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> > };
> > 
> > The result is:
> > 
> > ERROR: space prohibited before open square bracket '['
> > #2: FILE: testcase.c:2:
> > +       {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> > 
> > ERROR: space prohibited before open square bracket '['
> > #3: FILE: testcase.c:3:
> > +       {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
> > 
> > total: 2 errors, 0 warnings, 5 lines checked
> > 
> > NOTE: Ignored message types: COMPLEX_MACRO CONSIDER_KSTRTO MINMAX
> > MULTISTATEMENT_MACRO_USE_DO_WHILE
> > 
> > testcase.c has style problems, please review.
> 
> Hmmm will have a look...

Thanks! I'd send a patch, but I'm now doing checkpatch cleanup of uboot sources 
so I'm just submitting a testcase and delegating the issue.

M

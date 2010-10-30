Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0J3V2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:28:11 -0400
Received: from mail.perches.com ([173.55.12.10]:3848 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0J3V2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:28:09 -0400
Subject: Re: [PATCH 02/39] arch/alpha: Update WARN uses
From: Joe Perches <joe@perches.com>
To: Matt Turner <mattst88@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=Po5RaY-mL62trrVm+kuK=0JV7z2oQcDJek4kE@mail.gmail.com>
References: <cover.1288471897.git.joe@perches.com>
	 <517a3d5c620dd4843a35a05c9a1c123b4b936cd9.1288471898.git.joe@perches.com>
	 <AANLkTi=Po5RaY-mL62trrVm+kuK=0JV7z2oQcDJek4kE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 14:28:07 -0700
Message-ID: <1288474087.366.145.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 17:17 -0400, Matt Turner wrote:
> On Sat, Oct 30, 2010 at 5:08 PM, Joe Perches <joe@perches.com> wrote:
> > Coalesce long formats.
> > Align arguments.
> > Signed-off-by: Joe Perches <joe@perches.com>
> >  arch/alpha/kernel/pci-sysfs.c |   14 ++++++--------
> >  1 files changed, 6 insertions(+), 8 deletions(-)
> > diff --git a/arch/alpha/kernel/pci-sysfs.c b/arch/alpha/kernel/pci-sysfs.c
> > @@ -44,10 +44,9 @@ static int __pci_mmap_fits(struct pci_dev *pdev, int num,
> > -       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on %s BAR %d "
> > -               "(size 0x%08lx)\n",
> > -               current->comm, sparse ? " sparse" : "", start, start + nr,
> > -               pci_name(pdev), num, size);
> > +       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
> > +            current->comm, sparse ? " sparse" : "", start, start + nr,
> > +            pci_name(pdev), num, size);
> > @@ -261,10 +260,9 @@ static int __legacy_mmap_fits(struct pci_controller *hose,
> > -       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on hose %d "
> > -               "(size 0x%08lx)\n",
> > -               current->comm, sparse ? " sparse" : "", start, start + nr,
> > -               hose->index, size);
> > +       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on hose %d (size 0x%08lx)\n",
> > +            current->comm, sparse ? " sparse" : "", start, start + nr,
> > +            hose->index, size);
> What's accomplished here? It looks like you joined two strings (which
> were separated as to not overflow the 80-char limit) and spaced a
> couple lines over.
> 
> I don't see how this makes anything clearer.

Hi Matt.

This one is just a whitespace cleanup.
Ignore it or nack it if you want.

The patch was generated mostly by script to standardize
the WARN uses.

Long formats are generally preferred for grep.
In this case, there's no particular value in the format
coalescing because the output isn't going to be found
with a grep.

There were other patches that are actual defect fixes.

cheers, Joe


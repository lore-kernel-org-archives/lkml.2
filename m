Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2F1T4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:56:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56133 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751801Ab2F1T4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:56:41 -0400
Message-ID: <1340913400.2602.19.camel@joe2Laptop>
Subject: Re: [PATCH 04/19] staging: comedi: adl_pci6208: document the
 register map of the device
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Whitcroft <apw@canonical.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, fmhess@users.sourceforge.net,
        abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 28 Jun 2012 12:56:40 -0700
In-Reply-To: <20120628190602.GM5333@mwanda>
References: <201206271456.44218.hartleys@visionengravers.com>
	 <20120628190602.GM5333@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 22:06 +0300, Dan Carpenter wrote:
> On Wed, Jun 27, 2012 at 02:56:43PM -0700, H Hartley Sweeten wrote:
> > Add defines for the register map of the device. These will be
> > used to clarify the code.
[]
> > diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
[]
> > @@ -53,6 +53,18 @@ References:
> >   */
> >  #include "../comedidev.h"
> >  
> > +/*
> > + * PCI-6208/6216-GL register map
> > + */
> > +#define PCI6208_AO_CONTROL(x)		(0x00 + (2 * (x)))
> > +#define PCI6208_AO_STATUS		0x00
> > +#define PCI6208_AO_STATUS_DATA_SEND	(1 << 0)
> > +#define PCI6208_DIO			0x40
> > +#define PCI6208_DIO_DO_MASK		(0x0f)
> > +#define PCI6208_DIO_DO_SHIFT		(0)
> > +#define PCI6208_DIO_DI_MASK		(0xf0)
> > +#define PCI6208_DIO_DI_SHIFT		(4)
[]
> Does checkpatch.pl complain if you leave off these parenthesis?

checkpatch does not complain about those.
I also think parentheses around constants aren't necessary.

I think it's useful around the shifts and necessary
with the arithmetic.

It might be useful to add a (--strict?) test for those
extra parentheses.

Maybe something like:

 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e5bd60f..b6b4d6b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2888,6 +2888,11 @@ sub process {
 			     "Whitepspace after \\ makes next lines useless\n" . $herecurr);
 		}
 
+		if ($line =~ /^.\s*#\s*define\s+$Ident\s+\(\s*($Constant)\s*\)\s*$/) {
+			CHK("UNNECESSARY_PARENTHESIS",
+			    "Unnecessary parenthesis in #define around constant $1\n" . $herecurr);
+		}
+
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
 		if ($tree && $rawline =~ m{^.\s*\#\s*include\s*\<asm\/(.*)\.h\>}) {
 			my $file = "$1.h";



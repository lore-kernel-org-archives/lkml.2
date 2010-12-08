Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0LHQYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:24:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:42345 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0LHQYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:24:07 -0500
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
From: James Bottomley <James.Bottomley@suse.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1291825220.1741.9.camel@leonhard>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site> <1291738348.1638.9.camel@leonhard>
	 <1291739449.17668.9.camel@mulgrave.site>
	 <1291742693.1638.22.camel@leonhard>  <1291825220.1741.9.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 10:24:02 -0600
Message-ID: <1291825442.24312.54.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 01:20 +0900, Namhyung Kim wrote:
> 2010-12-08 (수), 02:24 +0900, Namhyung Kim:
> > 2010-12-07 (화), 10:30 -0600, James Bottomley:
> > > On Wed, 2010-12-08 at 01:12 +0900, Namhyung Kim wrote:
> > > > MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MODULE) so
> > > > allyesconfig build always emits the warnings. Possible patch for this
> > > > would be wraping it up in #ifdefs but when I sent a same patch to Greg
> > > > KH he didn't want to add more #ifdefs in .c files.
> > > 
> > > I didn't mean changing any c files.  I meant fixing the module include
> > > to make the table used even in the !MODULE case.  That way we only alter
> > > one file instead of a significant proportion of the drivers.
> > > 
> > 
> > It would not be a _significant_ proportion because normal drivers may
> > refer the table in their driver struct. :)
> > 
> > Anyway the patch below looks good to me. I'll happily drop my patches if
> > you apply this in your tree.
> > 
> 
> Hi,
> 
> As akpm told me, using DEFINE_PCI_DEVICE_TABLE could also remove the
> warnings (probably by making the table const) but it still requires
> modifying .c files. What do you think?

The warning only appears in the non-modular case, which is pretty
unusual for drivers nowadays, so I think the simplest elimination
solution is the best one (i.e. just kill it at source in the header).

James



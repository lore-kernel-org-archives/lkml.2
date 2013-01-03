Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3ACQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:28:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34811 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753402Ab3ACQ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:28:14 -0500
Message-ID: <1357230494.25181.55.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: prefer dev_<level>( to
 dev_printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        bp@alien8.de, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Jan 2013 08:28:14 -0800
In-Reply-To: <20130103100808.GG2649@dm>
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
	 <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
	 <1357171594.25181.19.camel@joe-AO722> <20130103100808.GG2649@dm>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 10:08 +0000, Andy Whitcroft wrote:
> On Wed, Jan 02, 2013 at 04:06:34PM -0800, Joe Perches wrote:
> > Add YA check to printk style.
> > 
> > dev_<level> uses are functions and generate smaller
> > object code than dev_printk(KERN_<LEVEL>.
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > +		if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
> > +			my $orig = $1;
> > +			my $level = lc($orig);
> > +			$level = "warn" if ($level eq "warning");
> > +			my $level2 = $level;
> > +			$level2 = "dbg" if ($level eq "debug");
> 
> Is there some sublty I am not seeing here such that level2 is necessary?

No, your vision is 20/20, it's not necessary.

It was a copy/paste from the pr_<level> conversion above it
where 2 styles to convert to (dev_dbg and pr_debug) are used.

Here there is just one form and your review is appreciated.
I'll submit a V2 later.



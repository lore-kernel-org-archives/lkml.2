Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3ACAj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:39:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39485 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753058Ab3ACAjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:39:54 -0500
Message-ID: <1357173594.25181.27.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: prefer dev_<level>( to
 dev_printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Lance Ortiz <lance.ortiz@hp.com>,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        bp@alien8.de, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Jan 2013 16:39:54 -0800
In-Reply-To: <CAErSpo51SUYBOj89RM7SSBPEEGW6dddjWUX53u0srZS_eqkbSA@mail.gmail.com>
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
	 <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
	 <1357171594.25181.19.camel@joe-AO722>
	 <CAErSpo51SUYBOj89RM7SSBPEEGW6dddjWUX53u0srZS_eqkbSA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 18:34 -0600, Bjorn Helgaas wrote:
> On Wed, Jan 2, 2013 at 6:06 PM, Joe Perches <joe@perches.com> wrote:
> > Add YA check to printk style.
> >
> > dev_<level> uses are functions and generate smaller
> > object code than dev_printk(KERN_<LEVEL>.
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > @@ -2430,6 +2430,16 @@ sub process {
> >                              "Prefer pr_warn(... to pr_warning(...\n" . $herecurr);
> >                 }
> >
> > +               if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
> > +                       my $orig = $1;
> > +                       my $level = lc($orig);
> > +                       $level = "warn" if ($level eq "warning");
> > +                       my $level2 = $level;
> > +                       $level2 = "dbg" if ($level eq "debug");
> > +                       WARN("PREFER_DEV_LEVEL",
> > +                            "Prefer dev_$level2(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
> 
> This suggests dev_dbg() instead of dev_printk(KERN_DEBUG), doesn't it?
>  Those aren't equivalent (dev_printk() always does the printk, but in
> many cases dev_dbg() does not, depending on CONFIG_DEBUG,
> CONFIG_DYNAMIC_DEBUG, etc.)

True, I think the suggested change is appropriate though.

If people really want debug output in a specific file,
then they should #define DEBUG and/or enable dynamic debug.


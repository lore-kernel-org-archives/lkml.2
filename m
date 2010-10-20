Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab0JTDyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:54:38 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45999 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab0JTDyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:54:37 -0400
Date: Tue, 19 Oct 2010 20:53:46 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
Message-ID: <20101020035346.GA20178@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
 <20101020032938.GA20095@ericsson.com>
 <1287545658.10409.606.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287545658.10409.606.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:34:18PM -0400, Joe Perches wrote:
> On Tue, 2010-10-19 at 20:29 -0700, Guenter Roeck wrote:
> > On Tue, Oct 19, 2010 at 07:13:40PM -0400, Joe Perches wrote:
> > > Convert printks to pr_<level>
> > > Coalesce long formats
> > > Removed prefixes from formats
> > > Added #define pr_fmt KBUILD_MODNAME ": " fmt
> > > Standardized abitguru messages for reporting and finding MAINTAINER
> > > Compiled x86 allyesconfig only.
> > > I inspected "strings drivers/hwmon/built-in.o",
> > > but it's otherwise untested.
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > There are several lines longer than 80 characters.
> > Does this rule no longer apply ?
> 
> 80 columns isn't checked for printk format strings.
> 
Interesting.

> A kernel general preference may be to keep formats as
> a single string without line breaks so that grep works
> better.
> 
> > Oddly enough, there are only four checkpatch warnings about long lines,
> > even though there are many more.
> 
> The version I use doesn't show any warnings.
> 
checkpatch.pl from both v2.6.36-rc7 and v2.6.36-rc6 do report warnings.
Looks like those versions flag long lines for pr_warn. Is your version
older or newer ?

Anyway, would it be possible to split the patch into one patch per file ?

I don't know how Jean thinks about it, but in my opinion it would be cleaner,
permit revert on a single patch/file instead of having to revert the entire series,
it would simplify review, and it would make it much easier to cherry-pick 
pieces into other releases if needed.

Thanks,
Guenter 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0JTHfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:35:13 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10899 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab0JTHfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:35:11 -0400
Date: Wed, 20 Oct 2010 09:34:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
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
Message-ID: <20101020093438.07b129c8@endymion.delvare>
In-Reply-To: <1287547662.10409.618.camel@Joe-Laptop>
References: <1287530020.10409.594.camel@Joe-Laptop>
	<20101020032938.GA20095@ericsson.com>
	<1287545658.10409.606.camel@Joe-Laptop>
	<20101020035346.GA20178@ericsson.com>
	<1287547662.10409.618.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 21:07:42 -0700, Joe Perches wrote:
> On Tue, 2010-10-19 at 20:53 -0700, Guenter Roeck wrote:
> > On Tue, Oct 19, 2010 at 11:34:18PM -0400, Joe Perches wrote:
> > > On Tue, 2010-10-19 at 20:29 -0700, Guenter Roeck wrote:
> > > > There are several lines longer than 80 characters.
> > > > Does this rule no longer apply ?
> > > 80 columns isn't checked for printk format strings.
> > Interesting.
> > > A kernel general preference may be to keep formats as
> > > a single string without line breaks so that grep works
> > > better.
> > > > Oddly enough, there are only four checkpatch warnings about long lines,
> > > > even though there are many more.
> > > The version I use doesn't show any warnings.
> > checkpatch.pl from both v2.6.36-rc7 and v2.6.36-rc6 do report warnings.
> > Looks like those versions flag long lines for pr_warn. Is your version
> > older or newer ?
> 
> Newer.  It adds pr_warn to the exempted list, not just pr_warning.

I hope there's a plan to get rid of one of these? Having two macros
doing exactly the same thing will confuse everybody.

> > Anyway, would it be possible to split the patch into one patch per file ?
> 
> Oh sure.  It's trivial to do that.
> 
> > I don't know how Jean thinks about it, but in my opinion it would be cleaner,
> > permit revert on a single patch/file instead of having to revert the entire series,
> > it would simplify review, and it would make it much easier to cherry-pick 
> > pieces into other releases if needed.
> 
> Jean, do you have a preference?
> I'll resubmit if you want it separated.

Jean has no preference when sleeping.

Now Jean is awake and can express himself on the matter:

* This isn't the kind of fixes we want to cherry-pick from. We're not
  fixing any bug here, are we? I certainly hope that a real bug fix
  wouldn't be hidden within a larger patch, but would have the separate
  patch it deserves. At which point we no longer care if the rest is
  one large patch or one patch per driver.

* I don't see us reverting that kind of patch either. If we don't like
  the changes for whatever reason, we don't take them in the first
  place. Once in, we're not going to change our minds.

* 32 patches for a simple cleanup is actually a lot more work for me
  than a single large patch. It's cheaper for me to do minor
  adjustments to a large patch than to apply 32 patches individually.

* That being said, now that the hwmon subsystem maintainer is a shared
  duty between Guenter and myself, there's no single place where we can
  keep a patch touching many drivers and ensure it doesn't conflict
  with the changes in the other tree. But I would think   this is
  something for Gunter and myself to sort out, not patch contributors.

I currently have pending patches to the following hwmon drivers in my
tree: adt7475, ams, asc7621, hdaps, it87, k8temp, lm75, lm85, lm90,
pcf8591, s3c-hwmon, w83795. Two of these are affected by Joe's
patch(es). Guenter, what about you?

Joe, would you mind providing a similar patch for the driver at:
  http://khali.linux-fr.org/devel/misc/w83795/w83795.c
This driver will be added to kernel 2.6.37.

-- 
Jean Delvare

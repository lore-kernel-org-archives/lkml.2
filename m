Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1HJJQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:16:06 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:43615 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1HJJQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:16:04 -0400
Date: Wed, 10 Aug 2011 05:15:50 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110810091550.GA383@flamenco.cs.columbia.edu>
References: <20110805174728.GA1741@flamenco.cs.columbia.edu>
 <4E3F97EA.2020600@ge.com>
 <20110808091432.GA19570@flamenco.cs.columbia.edu>
 <4E3FABDA.8080204@ge.com>
 <20110808101140.GA21300@flamenco.cs.columbia.edu>
 <4E3FC33D.2080202@ge.com>
 <20110808172216.GA2311@flamenco.cs.columbia.edu>
 <4E40F719.1020100@ge.com>
 <20110809191915.GB28746@flamenco.cs.columbia.edu>
 <4E42359B.2050105@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E42359B.2050105@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 08:39:07 +0100, Martyn Welch wrote:
> And I think you need to go and do a grep of the code and find out where those
> functions are actually used, rather than blindly relying on the comment.
(snip)
> Go grep the code.

/me greps once again..

RapidIO: there are no rapidIO drivers upstream, only switches
and rionet, which does not manage RapidIO devices (it just sends
Ethernet packets on top of RapidIO's messaging).  So obviously
there aren't any callers.

PCI: pci_dev_get() referenced in 60 files.  Another way of
explicitly incrementing the refcount of a pci device is with
pci_get_device(), which searches in the device list for a
particular one by its vendor/device ID.  This function is
referenced in 127 files.

USB: usb_get_dev() referenced in 75 files.

There are also lots of direct calls to get_device() from .probe
methods of devices not tied to a particular bus.

Guess that was enough grepping.

> Suitable bug fixes are welcome.

I sent a fix (as part of an admittedly large patchset) in
Nov 2010[1], ie 9 months ago, you were sick at the time and
told me you'd have a look at the changes later[2], which
unfortunately never happened, even after pinging you off-list.

Anyway let's forget that, Manohar's patches are what matters now.

		Emilio

[1] http://thread.gmane.org/gmane.linux.kernel/1054034
[2] http://thread.gmane.org/gmane.linux.kernel/1054034/focus=9819


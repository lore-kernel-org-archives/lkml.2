Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2INOk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:40:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60309 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2INOkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:40:55 -0400
Date: Fri, 14 Sep 2012 15:40:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] i915: Quirk out disconnected backlight
Message-ID: <20120914144049.GB8195@srcf.ucam.org>
References: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca>
 <20120914134853.GA6533@srcf.ucam.org>
 <1347632954.21322.44.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347632954.21322.44.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 03:29:14PM +0100, David Woodhouse wrote:
> On Fri, 2012-09-14 at 14:48 +0100, Matthew Garrett wrote:
> > On Fri, Sep 14, 2012 at 01:57:06PM +0100, Grant Likely wrote:
> > 
> > > Tested on MacbookPro8,3. Without this patch both the intel_backlight and
> > > gmux_backlight devices get registered and userspace doesn't know which
> > > it should use.
> > 
> > Userspace should be figuring out which one to use from the type field.
> 
> It only does that if it's using gsd-backlight-helper to poke
> at /sys/class/backlight directly. If X exposes a backlight, (as it does
> for the Intel backlight), then gsd will just use that.

Yeah, X should be doing the same. If it's not then it's broken. OTOH, I 
do agree that if we already know that we can't do anything with the 
backlight (as is clearly the case if the PWM field is 0) we should just 
disable it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

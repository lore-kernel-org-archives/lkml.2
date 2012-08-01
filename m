Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2HATwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:52:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34570 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2HATwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:52:37 -0400
Date: Wed, 1 Aug 2012 14:52:29 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Andreas Heider <andreas@meetr.de>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: [PATCH] apple-gmux: Restore switch registers on suspend/resume
Message-ID: <20120801195229.GE22963@thinkpad-t410>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andreas Heider <andreas@meetr.de>,
	Arun Raghavan <arun.raghavan@collabora.co.uk>,
	linux-kernel@vger.kernel.org, airlied@redhat.com
References: <4FFCC7FB.1090609@meetr.de>
 <1343522547.2488.12.camel@shinybook.infradead.org>
 <1343524730.1962.5.camel@shinybook.infradead.org>
 <20120729193953.GA25132@srcf.ucam.org>
 <1343595171.2511.1.camel@shinybook.infradead.org>
 <20120729205859.GA25819@srcf.ucam.org>
 <20120731151856.GA19979@thinkpad-t410>
 <1343835344.26866.150.camel@shinybook.infradead.org>
 <20120801155914.GB22963@thinkpad-t410>
 <1343850102.26866.169.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343850102.26866.169.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:41:42PM +0100, David Woodhouse wrote:
> On Wed, 2012-08-01 at 10:59 -0500, Seth Forshee wrote:
> > I don't think the mini-DP port works at all with the integrated
> > graphics, at least not on a Macbook Pro 8,2. I played around with it
> > yesterday under OS X. When using the DGPU with an external monitor it
> > works fine, but any attempts to switch to the IGPU were rejected by the
> > drivers. If I forced it to the IGPU prior to connecting the external
> > monitor the screen just remained blank when I plugged it in, until I
> > switched back to the DGPU. It's odd though that the DDC can be switched
> > over to the IGPU.
> 
> I get a blank screen when I use the VGA adapter, and with the dual-link
> DVI adapter I get a barely responsive machine continually printing 
> [ 1076.439623] [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
> as described at https://bugzilla.redhat.com/show_bug.cgi?id=843779#c8
> And a blank screen.
> 
> I thought someone had said they'd got it working with a native DP
> monitor, rather than the converters.

Maybe, I don't have a native DP monitor.

> > Iirc you've got the 8,3, and I'd expect it to be identical to the 8,2 in
> > this respect. Also, the only reason my LVDS didn't work was because I
> > wasn't telling i915 to disable SSC. I've got a patch to add a quirk for
> > this that I'll send soon, since there still doesn't seem to be any way
> > to get the vbios for the Intel graphics.
> 
> I think your patch won't cover the 8,3.
> 
> 00:02.0 VGA compatible controller [0300]: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller [8086:0126] (rev 09) (prog-if 00 [VGA controller])
> 	Subsystem: Apple Computer Inc. Device [106b:00de]

Nope, the subsystem device id is different. But I can throw yours into
the patch.

Although Matthew did indicate earlier that he might have some ideas
about how to get the VBT, in which case the quirking wouldn't be
necessary.


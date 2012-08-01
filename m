Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2HAP71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:59:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33665 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab2HAP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:59:22 -0400
Date: Wed, 1 Aug 2012 10:59:14 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Andreas Heider <andreas@meetr.de>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: [PATCH] apple-gmux: Restore switch registers on suspend/resume
Message-ID: <20120801155914.GB22963@thinkpad-t410>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andreas Heider <andreas@meetr.de>,
	Arun Raghavan <arun.raghavan@collabora.co.uk>,
	linux-kernel@vger.kernel.org, airlied@redhat.com
References: <20120710160555.GA31562@srcf.ucam.org>
 <20120710163516.GE10194@thinkpad-t410>
 <4FFCC7FB.1090609@meetr.de>
 <1343522547.2488.12.camel@shinybook.infradead.org>
 <1343524730.1962.5.camel@shinybook.infradead.org>
 <20120729193953.GA25132@srcf.ucam.org>
 <1343595171.2511.1.camel@shinybook.infradead.org>
 <20120729205859.GA25819@srcf.ucam.org>
 <20120731151856.GA19979@thinkpad-t410>
 <1343835344.26866.150.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343835344.26866.150.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 04:35:44PM +0100, David Woodhouse wrote:
> On Tue, 2012-07-31 at 10:18 -0500, Seth Forshee wrote:
> > 
> > All of this is working to the extent that I can boot with the Radeon
> > card active, switch over to the Intel card, and get the EDID for the
> > internal panel and an external monitor (although oddly on an HDMI
> > connector, no on the DP like I expected). Both screens are remaining
> > blank though. However I'm also getting blank screens if I mux over to
> > the Intel GPU from grub before loading the kernel, which used to work
> > for the LVDS panel at least. 
> 
> Hm, when I was changing over to the external screen before boot, I could
> get the LVDS working but *not* an external VGA or DVI monitor (via the
> standard Apple adaptors). Should I expect that to work if I change the
> mux 'properly' at runtime?

I don't think the mini-DP port works at all with the integrated
graphics, at least not on a Macbook Pro 8,2. I played around with it
yesterday under OS X. When using the DGPU with an external monitor it
works fine, but any attempts to switch to the IGPU were rejected by the
drivers. If I forced it to the IGPU prior to connecting the external
monitor the screen just remained blank when I plugged it in, until I
switched back to the DGPU. It's odd though that the DDC can be switched
over to the IGPU.

Iirc you've got the 8,3, and I'd expect it to be identical to the 8,2 in
this respect. Also, the only reason my LVDS didn't work was because I
wasn't telling i915 to disable SSC. I've got a patch to add a quirk for
this that I'll send soon, since there still doesn't seem to be any way
to get the vbios for the Intel graphics.

Seth


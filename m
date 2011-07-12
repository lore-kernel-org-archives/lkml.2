Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1GLIDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:03:37 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52862 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1GLIDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:03:32 -0400
Date: Tue, 12 Jul 2011 09:03:26 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch.pl generates false alarm
Message-ID: <20110712080326.GA1065@shadowen.org>
References: <4E1B0D51.4000905@broadcom.com>
 <1310444606.6925.4.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310444606.6925.4.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 09:23:26PM -0700, Joe Perches wrote:
> On Mon, 2011-07-11 at 16:48 +0200, Roland Vossen wrote:
> > Hello Andy,
> > 
> > when I feed attached file to checkpatch, several warnings are given, but 
> > this one:
> > 
> > WARNING: externs should be avoided in .c files
> > #3555: FILE: staging/brcm80211/brcmsmac/main.c:3555:
> > +       END_FOREACH_BSS
> > 
> > does not seem to make sense. When I place a comment behind the 
> > END_FOREACH_BSS line, the checkpatch warning disappears.
> > 
> > Let me know if you need additional info to work on this.
> 
> I think this code is bad form and confuses checkpatch:
> 
> 	/* update the capability based on current shortslot mode */
> 	FOREACH_BSS(wlc, idx, cfg)
> 		if (!cfg->associated)
> 			continue;
> 		cfg->current_bss->capability &=
> 					~WLAN_CAPABILITY_SHORT_SLOT_TIME;
> 		if (wlc->shortslot)
> 			cfg->current_bss->capability |=
> 					WLAN_CAPABILITY_SHORT_SLOT_TIME;
> 	END_FOREACH_BSS
> 
> I think this code is still slightly bad form, but it isn't a problem
> for checkpatch:
> 
> 	/* update the capability based on current shortslot mode */
> 	FOREACH_BSS(wlc, idx, cfg) {
> 		if (!cfg->associated)
> 			continue;
> 		cfg->current_bss->capability &=
> 					~WLAN_CAPABILITY_SHORT_SLOT_TIME;
> 		if (wlc->shortslot)
> 			cfg->current_bss->capability |=
> 					WLAN_CAPABILITY_SHORT_SLOT_TIME;
> 	} END_FOREACH_BSS

Yeah I can only concur that this is the more normal form for such fake
loop structures which needs begins and ends.  I don't think we are going
to be able to trivially figure out this is a loop otherwise.

-apw

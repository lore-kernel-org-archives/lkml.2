Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0JBMdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 08:33:12 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:53745 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532Ab0JBMdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 08:33:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANLDpkxR8Uhp/2dsb2JhbACiPXLBQw2FNwQ
Date: Sat, 2 Oct 2010 14:33:09 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Giel van Schijndel <me@mortis.eu>
Cc: Lutz Ballaschke <vegan.grindcore@googlemail.com>,
        Wim van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/3] watchdog: add f71862fg support
Message-ID: <20101002123308.GG3823@infomag.iguana.be>
References: <20100926140629.GA2150@kreios.titan> <20100926151155.GB7185@salidar.me.mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100926151155.GB7185@salidar.me.mortis.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> On Sun, Sep 26, 2010 at 04:06:29PM +0200, Lutz Ballaschke wrote:
> > Furthermore i was thinking about modifying the WDIOC_GETTIMELEFT
> > helper function since it simply returns the content of the WDT timer 
> > register without regarding whether the driver runs in minute-mode or not
> > (thanks to Giel for pointing that out). This means if the driver is loaded 
> > with a timeout of >255 seconds (and switches to minute-mode) WDIOC_GETTIMELEFT
> > ioctl returns minutes instead of seconds and thus doesn't comply with 
> > watchdog-api (e.g. ioctl returns 6(min) not 360(sec)). It might be 
> > confusing if one loads the driver with a timeout of let's say 360 seconds 
> > and gets 6 minutes returned by ioctl. But imho it's not very accurate to
> > return a value of seconds if the wdt doesn't count in seconds. That might
> > be even more confusing. This inconsistency on the part of the hardware 
> > maybe can't get satisfyingly compensated by the driver. So i'd prefer the 
> > most simple solution.
> 
> IMO the worst option would be to just return minutes.  Returning
> 'minutes * 60 = seconds' would be significantly less bad.  So if these
> are your options I'd suggest going with the lesser evil.
> 
> One other possible option could be returning '(minutes - 1) * 60 + 1'.
> That way bad timing decisions based on the (wrong) assumption, that
> there are still 60 seconds left until reset, can be averted.
> 
> I would however like Wim's opinion on this, as this affects the
> Watchdog API's usage.

The return value should be the seconds before the watchdog will reboot.
So value should be seconds, not minutes and is best the safest value
(so (minutes - 1) * 60 + 1 in this case ).
Secondly: the WDIOC_GETTIMELEFT should only be a DEBUGging ioctl.
The reason I created it, is to check if certain drivers are working
or not. We should not use it in normal operations imho.

Kind regards,
Wim.


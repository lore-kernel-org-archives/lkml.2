Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1IFSoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:44:54 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:34623 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab1IFSos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:44:48 -0400
X-SENDER-IP: [85.230.168.63]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjBpACFpZk5V5qg/PGdsb2JhbABDiRWeaAsBAQEBNzOBRgEBBAE6HCMQCANGFCUKGogGArliDoV8YASYS4ty
X-IronPort-AV: E=Sophos;i="4.68,340,1312149600"; 
   d="scan'208";a="39017673"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 6 Sep 2011 20:47:35 +0200
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, JJ Ding <jj_ding@emc.com.tw>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 2/6] Input: elantech - use firmware provided x, y ranges
Message-ID: <20110906184735.GA3433@polaris.bitmath.org>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
 <1313632629-23603-3-git-send-email-jj_ding@emc.com.tw>
 <20110818074756.GE10093@core.coreip.homeip.net>
 <4E5FCE58.9060906@canonical.com>
 <87sjobk711.fsf@emc.com.tw>
 <4E665249.2040602@canonical.com>
 <20110906173649.GA7419@core.coreip.homeip.net>
 <4E6660D7.9040800@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6660D7.9040800@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> I see that the current code scales the coordinates for v2, but it's only
> >> half-resolution. That's not a huge deal since the resolution of modern
> >> touchpads is very high. We could leave it scaled to not break abi, if
> >> that was a concern. However, with new devices it makes sense to state
> >> the ranges in terms of what the device actually supports. Otherwise,
> >> we're just masking out useful data that userspace could be using.
> >>
> > 
> > I disagree. I believe that ST and MT ranges reported for the same
> > working surface should match, especially since many devices derive ST
> > data from MT.
> > 
> > As far as devices that have ranges 0-15 in MT mode - I am not sure how
> > useful such MT steam anyway and if we are better of just ignore them
> > (maybe just use the data to report number of fingers on the surface but
> > otherwise use standard ST protocol).
> 
> The MT data could still be useful for pinch to zoom or potentially
> rotate (though most low res devices probably are only semi-mt). I don't
> want to forsake pinch to zoom just because we can't pass on the
> resolution of MT data properly.

We are not forsaking anything. At best, the detail missed out by using
the same scaling for ST and MT is the ability to distinguish the axis
with the best or poorest resolution. However, some devices report
higher MT than ST resolution, not because it is better (it is indeed
worse), but simply to not lose bits in the filtering process. In other
words: the logic is not without corner cases, and it only makes a
difference to the transitional devices that are not fully MT
capable. If this really was a concern, userspace could use the ST
coordinates for some transformations instead.

Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0HDO7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:59:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42567 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab0HDO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:59:49 -0400
Date: Wed, 4 Aug 2010 10:52:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: WARNING at net/wireless/reg.c when wireless network is
 disconnected
Message-ID: <20100804145258.GC17666@tuxdriver.com>
References: <4C5950B7.4000802@archlinux.org>
 <20100804134908.GB17666@tuxdriver.com>
 <4C59790C.4010809@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C59790C.4010809@archlinux.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:28:28PM +0200, Thomas Bächler wrote:
> Am 04.08.2010 15:49, schrieb John W. Linville:
> > On Wed, Aug 04, 2010 at 01:36:23PM +0200, Thomas Bächler wrote:
> >> Hello,
> >>
> >> this warning has been around ever since I switched to 2.6.34, has
> >> accompanied me through the 2.6.35-rc* phase and is still there with
> >> 2.6.35. I didn't bother to report it so far, as there seems to be no harm.
> >>
> >> Whenever I disconnect/get disconnected from the wireless, I receive the
> >> below warning:
> >>
> >> ------------[ cut here ]------------
> >> WARNING: at net/wireless/reg.c:272
> >> regulatory_hint_disconnect+0x1b3/0x230 [cfg80211]()
> >> Hardware name: TECRA A11
> >> Unexpected user alpha2: de
> > 
> > Perhaps you need to set the regdomain as "DE" rather than "de"?
> > 
> > John
> 
> You are actually right. I did set it to "DE" with iw, but wpa_supplicant
> had a setting country="de". I just fixed that and will soon see if the
> problem disappears.
> 
> Still, the warning shouldn't look like a bad kernel bug, but rather an
> advisory to the user to set something sane. What confuses me even more
> is that this has been set to DE afterwards:

Perhaps we should just upcase the alpha2 value?  I'm not sure why we don't.

> $ dmesg | grep cfg80211:\ Calling\ CRDA
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: Calling CRDA for country: de
> cfg80211: Calling CRDA for country: DE
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: Calling CRDA for country: DE
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: Calling CRDA for country: DE
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: Calling CRDA for country: DE
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: Calling CRDA for country: DE
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: Calling CRDA for country: DE
> 
> The AP has been playing with the regdom as well, I lost track of what
> has been set where in this mess.

The AP is probably sending a country IE that indicates "DE".

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab1BBNjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 08:39:17 -0500
Received: from w1.fi ([128.177.27.249]:59514 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268Ab1BBNjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 08:39:14 -0500
Date: Wed, 2 Feb 2011 15:38:39 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Xin Jin <Xin.Jin@atheros.com>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
Message-ID: <20110202133839.GA14904@jm.kir.nu>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
 <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
 <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
 <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
 <1296633772.3624.2.camel@jlt3.sipsolutions.net>
 <20110202113052.GA14126@jm.kir.nu>
 <1296646434.5671.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296646434.5671.1.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 12:33:54PM +0100, Johannes Berg wrote:
> What's the driver_cmd things they use? If we they add support for
> whatever it is to nl80211, why can those not be normal supplicant
> interfaces?

I have not reviewed what exactly gets used and how, so this is only
based on what the modification for wpa_supplicant are exposing.

There seems to be some kind of mechanism for stopping/starting/reloading
the driver which I do not fully understand. It includes some kind of
driver hang detection and maybe recovery from that etc..

Then there is a very generic mechanism of passing any command from user
space (i.e., command string to a SIOCSIWPRIV) and that goes
transparently through wpa_supplicant.. The response comes back as a
string. In other words, you could implement pretty much anything in a
driver specific way with that.. At least following commands are used or
have used with that: RSSI, LINKSPEED, MACADDR, GETPOWER, GETBAND.

Since it is difficult to tell just from wpa_supplicant changes what
exactly is done with these interfaces, the answer to the question of
why these could not be normal supplicant interfaces is not immediately
clear to me. I would assume that some of this functionality could
certainly be added once identified clearly what is needed. Some may
already be available (like MACADDR; assuming it is used to fetch local
MAC address).

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1C3GEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 02:04:16 -0400
Received: from purkki.adurom.net ([80.68.90.206]:33101 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1C3GEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 02:04:15 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, devel@linuxdriverproject.org,
        Naveen Singh <nsingh@atheros.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Vipin Mehta <vmehta@atheros.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Update on Android PM enhancements - CONFIG_HAS_EARLYSUSPEND and friends
References: <AANLkTik69v+gdPzwdMSyVnvHMKbWquvfCFvHLmLu-bBB@mail.gmail.com>
	<AANLkTikurVF_-u8gTqM3ireKia28zMrkXRyrvdNTob7e@mail.gmail.com>
	<1300957495.3807.7.camel@jlt3.sipsolutions.net>
	<1300957590.3807.8.camel@jlt3.sipsolutions.net>
	<87k4fouamf.fsf@purkki.adurom.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 30 Mar 2011 09:03:54 +0300
In-Reply-To: <87k4fouamf.fsf@purkki.adurom.net> (Kalle Valo's message of "Thu\, 24 Mar 2011 11\:32\:40 +0200")
Message-ID: <87vcz1rvp1.fsf@purkki.adurom.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kalle Valo <kvalo@adurom.com> writes:

> In maemo, to save power, we decreased the dynamic power save timeout
> whenever display was turned off. This was all done from user space and
> wifi driver in the kernel was completely unaware of the display state.

[...]

> And before someone suggests adding dynamic timeout variable to
> nl80211: I think it's very much implementation specific parameter. Not
> all drivers support it and it might be that even in future mac80211
> uses something else. So having the timeout variable in nl80211 is not
> a long term solution.

I totally forgot that Juuso added QoS requirements support to
mac80211. And that's the proper wayq to do this, user space sets QoS
requirements based on display state, and whatever else it thinks is
important, and mac80211 adapts the power save parameters accordingly.
In this method we are not revealing any implemention details to user
space, and that's always a good thing.

-- 
Kalle Valo

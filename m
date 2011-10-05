Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab1JEJRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:17:37 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:55875 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab1JEJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:17:35 -0400
X-SENDER-IP: [85.230.170.153]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgZZAIgfjE5V5qqZPGdsb2JhbABCiTSeWxkBAQEBNzKBUwEBBAE6HCMFCwgDDjgUJQoaiBACtzcOhjphBJkijBE
X-IronPort-AV: E=Sophos;i="4.68,490,1312149600"; 
   d="scan'208";a="490444882"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 5 Oct 2011 11:23:41 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - use monotonic clock for event timestamps
Message-ID: <20111005092341.GB6840@polaris.bitmath.org>
References: <1317624200-9762-1-git-send-email-djkurtz@chromium.org>
 <20111003090641.GA5615@polaris.bitmath.org>
 <CAGS+omAj9z2-Au2HABtDKHQGRBNVxXygF2cz+L8UMeTHRrMjbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omAj9z2-Au2HABtDKHQGRBNVxXygF2cz+L8UMeTHRrMjbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I understand your concern about breaking random drivers, and am hoping
> that someon on this list could indicate whether this is a real concern
> or not.  To get a better feeling for possible regressions, I checked
> xf86-input-evdev & -synaptics, and neither uses the evdev timestamp in
> their current incarnations.  Any idea what else might be a good place
> to check?

The input system is used for all sorts of events - switches, for
instance. The point is that it is nearly impossible to know if
something will break or not, hence the reluctance to modify interfaces.

> One option is to make the evdev timestamp clock source a per-driver
> configuration option (controllable from userspace?).  This sounds like
> it is doable, but would be significantly more complicated.
> 
> Another option would be to timestamp with monotonicraw + boottime +
> sleeptime.  This would be approximately wall clock time, but without
> ntp and slew adjustments.  But, I fear this would just make the rare
> driver issue less obvious, since it would only become obvious when the
> two clock sources started drifting apart.

I agree, the problem is not really solvable. Dmitry?

Thanks,
Henrik

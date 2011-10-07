Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab1JGK7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:59:34 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:60609 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759767Ab1JGK7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:59:32 -0400
X-SENDER-IP: [85.230.171.1]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnBNAFzbjk5V5qsBPGdsb2JhbABEiTuefxkBAQEBNzKBUwEBBAE6HCMFCwgDRhQlChqIEQK3cQ6GQ2EEmSWMEw
X-IronPort-AV: E=Sophos;i="4.68,501,1312149600"; 
   d="scan'208";a="490508533"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 7 Oct 2011 13:05:42 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chasedouglas@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - use monotonic clock for event timestamps
Message-ID: <20111007110542.GA5333@polaris.bitmath.org>
References: <1317624200-9762-1-git-send-email-djkurtz@chromium.org>
 <20111003090641.GA5615@polaris.bitmath.org>
 <CAGS+omAj9z2-Au2HABtDKHQGRBNVxXygF2cz+L8UMeTHRrMjbA@mail.gmail.com>
 <20111005092341.GB6840@polaris.bitmath.org>
 <4E8C6B1F.4090904@gmail.com>
 <20111006034202.GC20217@core.coreip.homeip.net>
 <CAGS+omDF3mi_tXXxHR2XOyjJMfuc=j2rWBMctJRGr7GeeE+yRg@mail.gmail.com>
 <20111007063617.GA6167@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007063617.GA6167@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > if the values don't change.  The timestamp axis
> > would always change, hence it would always be sent, even if no other
> > axes change.  Of course, we can mitigate this with special-case
> > handling of the ABS_TIMESTAMP in the evdev layer.
> > 
> 
> I'd prefer if we go this route then:
> 
> 1. Have input core emit this event. Then we could decide if we should
> suppress it when suppressing entire packet.

If we go this route, we could also make use of the time stamps of the
hardware, when existent.

> 2. Make it MSC_ event.
> 3. Turn it on and off via ioctl since not all users are interested in
> this facility.

Perhaps it is time for the per-file-descriptor event filters.

> OTOH if we do ioctl why don't we simply allow usres select monotnic vs
> wall time in event structure.
> 
> Still, why does your clock fluctuate so much that it matters?

Yes, some actual experimental timing data would be most interesting.

Thanks,
Henrik

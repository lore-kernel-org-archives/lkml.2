Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1HKUdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:33:22 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:37268 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab1HKUdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:33:17 -0400
X-Greylist: delayed 1617 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Aug 2011 16:33:16 EDT
X-SENDER-IP: [85.230.168.63]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At53AGc1RE5V5qg/PGdsb2JhbABBiQ+eSAsBAQEBNzKBQAEBBAEyASMjBQsIAw44FCUKGogCAr1pDoVaXwSYJ4MiiDY
X-IronPort-AV: E=Sophos;i="4.67,358,1309730400"; 
   d="scan'208";a="211174759"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 11 Aug 2011 22:07:08 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 8/9 v2] Input: add BTN_TOOL_QUINTTAP for reporting 5
 fingers on touchpad
Message-ID: <20110811200708.GA6084@polaris.bitmath.org>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-9-git-send-email-djkurtz@chromium.org>
 <20110725082918.GC22937@core.coreip.homeip.net>
 <CAGS+omAQmb-q6xC-Gh6z69iNNyr=rN-Khsq90aCHJwe-6F9ANw@mail.gmail.com>
 <20110725181645.GA6876@core.coreip.homeip.net>
 <CAGS+omCAUAgK6thEPqkp0iSFbnzonw0jH77XToptTwTUz5BH7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omCAUAgK6thEPqkp0iSFbnzonw0jH77XToptTwTUz5BH7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That, or nothing... The fact that the device can report 5 finger touch
> > does not mean that anybody cares about this.
> > --
> > Dmitry
> 
> The only current use of this is to detect "resting thumb + 4-finger-scroll".
> "4-finger scroll" is a gesture supported by some applications and
> operating systems.
> "resting thumb" is when a clickpad user rests a finger (typically a
> thumb), in the bottom left "click zone" in anticipation of
> click+move=select gestures.
> Thus, this 4-finger scroll is actually sometimes a 5-finger gesture.

Which is actually the same reason QUADTAP was added originally... are
we entering a recursion here? ;-)

I tend to agree with Dmitry - without a clear usage, it makes sense to
instead wait to see which comes first - a five-finger usecase or a
true MT device that everybody can afford.

> Similarly, I work with many touchpads from different vendors, some of
> which do actually provide 5 independent finger coordinates.  The
> drivers for these touchpads truly send 5 MT-B slots when 5 fingers are
> present.
> 
> Should these drivers perform input_mt_report_pointer_emulation()?
> If so, should we add BTN_TOOL_QUINTTAP to allow them to report 5
> fingers in emulation mode?

Pointer emulation is a separate issue from the number of finger
reports.

> Or is that ridiculous, since emulation is only for old userspace
> programs which wouldn't know what to do with QUINTTAP, anyway?

I would say yes. ;-)

Cheers,
Henrik

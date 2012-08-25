Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2HYTlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:41:08 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:58815 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2HYTlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:41:06 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhxMABgpOVBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngiABAQQBOhwjBQsIAw44FCUKGogaCrtqFJElYAOVVIVsjQ8
X-IronPort-AV: E=Sophos;i="4.77,827,1336341600"; 
   d="scan'208";a="399816492"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 25 Aug 2012 21:46:16 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/19] Input: evdev - Add the events() callback
Message-ID: <20120825194616.GA4780@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
 <1344807757-2217-8-git-send-email-rydberg@euromail.se>
 <CAGS+omCRsi=irbHXsDah48nOOMHYrNCCsnstCdqUTRvi=ZU99Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omCRsi=irbHXsDah48nOOMHYrNCCsnstCdqUTRvi=ZU99Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reading the time just once and applying it as the timestamp to an
> entire frame is very nice.
> However, is it ever possible for the SYN_REPORT to get delayed until
> the next batch of input_values, therefore breaking the assumption that
> the SYN_REPORT timestamp applies to the rest of the input_values for
> its frame?

Yes, but see reply to previous patch.

> Also, bonus points if the input driver could set this input frame
> timestamp based on when it first saw a hardware interrupt rather then
> when evdev gets around to sending the frame to userspace.  This could
> potentially remove a lot of the timing jitter userspace sees when
> computing ballistics based on input event timestamps.

In principle, yes (it has been discussed before), but in practise some
devices provide timestamps and some not, and the scale and granularity
may vary. In addition, desktop userland (read X input) does not even
use the kernel timestamp, so the effect would not even be seen without
a synchronized effort. I am not saying it is a bad idea, but it has
some details to get straight before it becomes useful.

Thanks,
Henrik

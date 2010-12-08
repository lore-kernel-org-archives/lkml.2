Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0LHSXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:23:33 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:33807 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755937Ab0LHSXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:23:32 -0500
Message-ID: <4CFFCD10.5030202@euromail.se>
Date: Wed, 08 Dec 2010 19:23:12 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se> <4CFFC3C2.1080905@canonical.com>
In-Reply-To: <4CFFC3C2.1080905@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQOfZ-0005jE-CF.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQOfZ-0005jE-CF 4c874167f6d455578839210a85c8dc88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch represents an MT solution for those devices that can detect

>> and report some effects of dual touch, but cannot report individual
>> contacts. Synaptics and elantech are two examples. Having the drivers
>> report the bounding rectangle of the touches is useful in userland,
>> since the information makes it possible to implement zooming
>> gestures. At the same time, it would be confusing to send these
>> envelope points as fingers, since they clearly are not. As a remedy,
>> introduce MT_TOOL_ENVELOPE, which tells applications that care about
>> details that these are not real fingers, at the same time as it allows
>> gesture applications based on MT data to function without
>> modification.
> 
> Is it assumed that the envelop has only two touches comprising it? Or is
> it any number of touches? If it's any number of touches, how does one
> know how many touches it is?


It could be any number of points, although, as you say, the exact semantics of
multiple points have not yet been defined/documented. Traditionally, a convex
hull is defined as a sequence of points, such that the last links to the first.
It makes sense to define the envelope points similarly. However, we can pass
that bridge as we get there. Right now, we have use for the two-point case. The
number is determined the same was as for fingers - count the number of active slots.

> How are the envelop shape and position determined?


I was imagining a convex polygon shape, but frankly, I see no immediate use for
anything but the bounding rectangle.

> I think the idea is good, I just don't have enough information to
> understand how the tool type is supposed to be used. This has been an
> issue with many evdev properties, so I'm hoping we can provide more
> detailed documentation this time around :).


Yes, it is a good point. The current patch at least documents the intended use,
and seems apt for the moment. We can always add more as the concept matures.

Thanks,
Henrik

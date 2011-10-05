Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742Ab1JEOfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:35:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46509 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462Ab1JEOfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:35:16 -0400
Message-ID: <4E8C6B1F.4090904@gmail.com>
Date: Wed, 05 Oct 2011 15:35:11 +0100
From: Chase Douglas <chasedouglas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Daniel Kurtz <djkurtz@chromium.org>, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - use monotonic clock for event timestamps
References: <1317624200-9762-1-git-send-email-djkurtz@chromium.org> <20111003090641.GA5615@polaris.bitmath.org> <CAGS+omAj9z2-Au2HABtDKHQGRBNVxXygF2cz+L8UMeTHRrMjbA@mail.gmail.com> <20111005092341.GB6840@polaris.bitmath.org>
In-Reply-To: <20111005092341.GB6840@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 10:23 AM, Henrik Rydberg wrote:
>> I understand your concern about breaking random drivers, and am hoping
>> that someon on this list could indicate whether this is a real concern
>> or not.  To get a better feeling for possible regressions, I checked
>> xf86-input-evdev & -synaptics, and neither uses the evdev timestamp in
>> their current incarnations.  Any idea what else might be a good place
>> to check?
> 
> The input system is used for all sorts of events - switches, for
> instance. The point is that it is nearly impossible to know if
> something will break or not, hence the reluctance to modify interfaces.
> 
>> One option is to make the evdev timestamp clock source a per-driver
>> configuration option (controllable from userspace?).  This sounds like
>> it is doable, but would be significantly more complicated.
>>
>> Another option would be to timestamp with monotonicraw + boottime +
>> sleeptime.  This would be approximately wall clock time, but without
>> ntp and slew adjustments.  But, I fear this would just make the rare
>> driver issue less obvious, since it would only become obvious when the
>> two clock sources started drifting apart.
> 
> I agree, the problem is not really solvable. Dmitry?

We could put it into the -next tree early on in the cycle, and then it
will be in -next for a cycle and in Linus' tree for the real dev cycle.
By that time we would hope any issues would have emerged.

I'm not sure if that is a responsible approach. I agree that the change
would be good, but how sure would we be that nothing would break based
only on testing in development trees?

My personal thoughts are that I doubt it would cause issues. Based on
that gut feel, I would say that this approach is reasonable. However,
I'm just one voice in all this :).

-- Chase

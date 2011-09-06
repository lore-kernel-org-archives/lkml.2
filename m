Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1IFS6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:58:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1IFS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:58:36 -0400
Message-ID: <4E666D56.1020009@canonical.com>
Date: Tue, 06 Sep 2011 11:58:30 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, JJ Ding <jj_ding@emc.com.tw>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 2/6] Input: elantech - use firmware provided x, y ranges
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-3-git-send-email-jj_ding@emc.com.tw> <20110818074756.GE10093@core.coreip.homeip.net> <4E5FCE58.9060906@canonical.com> <87sjobk711.fsf@emc.com.tw> <4E665249.2040602@canonical.com> <20110906173649.GA7419@core.coreip.homeip.net> <4E6660D7.9040800@canonical.com> <20110906184735.GA3433@polaris.bitmath.org>
In-Reply-To: <20110906184735.GA3433@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 11:47 AM, Henrik Rydberg wrote:
>>>> I see that the current code scales the coordinates for v2, but it's only
>>>> half-resolution. That's not a huge deal since the resolution of modern
>>>> touchpads is very high. We could leave it scaled to not break abi, if
>>>> that was a concern. However, with new devices it makes sense to state
>>>> the ranges in terms of what the device actually supports. Otherwise,
>>>> we're just masking out useful data that userspace could be using.
>>>>
>>>
>>> I disagree. I believe that ST and MT ranges reported for the same
>>> working surface should match, especially since many devices derive ST
>>> data from MT.
>>>
>>> As far as devices that have ranges 0-15 in MT mode - I am not sure how
>>> useful such MT steam anyway and if we are better of just ignore them
>>> (maybe just use the data to report number of fingers on the surface but
>>> otherwise use standard ST protocol).
>>
>> The MT data could still be useful for pinch to zoom or potentially
>> rotate (though most low res devices probably are only semi-mt). I don't
>> want to forsake pinch to zoom just because we can't pass on the
>> resolution of MT data properly.
> 
> We are not forsaking anything. At best, the detail missed out by using
> the same scaling for ST and MT is the ability to distinguish the axis
> with the best or poorest resolution. However, some devices report
> higher MT than ST resolution, not because it is better (it is indeed
> worse), but simply to not lose bits in the filtering process. In other
> words: the logic is not without corner cases, and it only makes a
> difference to the transitional devices that are not fully MT
> capable. If this really was a concern, userspace could use the ST
> coordinates for some transformations instead.

So what do we want userspace to do? In the absence of supplying this
information we need to provide guidelines. We could say:

* Always use ST coords + finger count for drag gestures (i.e. scrolling)
* Use MT coords for pinch and rotate

If this is acceptable, we should add it to the documentation. Thoughts?

-- Chase

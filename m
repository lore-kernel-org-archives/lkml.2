Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0LHSxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:53:09 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:46969 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756213Ab0LHSxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:53:05 -0500
Message-ID: <4CFFD3FE.1090103@euromail.se>
Date: Wed, 08 Dec 2010 19:52:46 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se> <4CFFC3C2.1080905@canonical.com> <4CFFCD10.5030202@euromail.se> <4CFFD0BF.2020601@canonical.com>
In-Reply-To: <4CFFD0BF.2020601@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQP8B-0003Zq-BJ.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQP8B-0003Zq-BJ 6694ddc457cba93919fc50b736517ee1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> It could be any number of points, although, as you say, the exact semantics
>> of multiple points have not yet been defined/documented. Traditionally, a
>> convex hull is defined as a sequence of points, such that the last links to
>> the first. It makes sense to define the envelope points similarly. However,
>> we can pass that bridge as we get there. Right now, we have use for the
>> two-point case. The number is determined the same was as for fingers - count
>> the number of active slots.

>
> Ahh. That leaves me with two thoughts:
> 
> 1. A real convex hull would imply that the points given are correct.
> This is the fundamental issue with these touchpads though, and I feel
> envelope semantics would only help solve a different problem: touch
> object shape.


We have blobs for this case, which is a question in itself. Touch shape has some
basic properties, but common to them all is that all events apply to one touch
id. The envelope points, on the other hand, have different touch ids. Hence, I
think the chance of eventual mixup is still remote. Also, I am not necessarily
thinking of blobs as the first step towards more general shapes. (A pole
expansion might be more useful to applications, for instance.)

> As you noted, what we are really interested here is a bounding
> rectangle. I think Ping has said that Wacom could provide something that
> is similar to a real convex hull, and mixing the two concepts together
> could cause another ambiguity like BTN_TOOL_DOUBLETAP :).


True, we should work towards avoiding such ambiguities.

> I suggest merely renaming this to MT_TOOL_RECT to avoid confusion.
> 
> 2. We could provide for multiple simultaneous rects by using the value
> of the MT_TOOL_RECT property. The first rect would have value 0, the
> second would have value 1, etc. I don't know if this will ever be used
> since most devices will have real MT soon enough, but it wouldn't hurt
> to define this.


I do think this is an unnecessary complication.

Thanks,
Henrik

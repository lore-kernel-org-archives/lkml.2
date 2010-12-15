Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab0LOOVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:21:55 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:33350 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942Ab0LOOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:21:53 -0500
Message-ID: <4D08CEE8.9080804@euromail.se>
Date: Wed, 15 Dec 2010 15:21:28 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: synaptics - add multitouch packet support
References: <1292280948-1933-1-git-send-email-rydberg@euromail.se> <4D06A7B1.6060609@canonical.com> <4D06A90C.90009@euromail.se> <4D07E38C.4020201@canonical.com>
In-Reply-To: <4D07E38C.4020201@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSsEZ-0002lk-74.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PSsEZ-0002lk-74 09e2ba208b523b6412a077f6440c7d2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> After some testing this is mostly fine,

 but I have one of those terrible
> "integrated buttons" (or whatever we call it) trackpads. When switching
> to multitouch mode, the cursor will sometimes jump when I go to push the
> button.
> 
> Take the following sequence:
> 
> 1. Touch in top right corner of pad to position cursor
> 2. Touch in bottom left corner over button
> 3. Press button, but finger moves a little
> 
> Step 3 causes the primary coordinates in the synaptics MT protocol to
> flip to the button-pressing touch. This causes a cursor jump. *Many*
> times I have gone to press an "Ok" dialog button and found that I
> accidentally launched an application from my dock :).


I see - the behavior of the primary coordinates seems to vary between models,
then. On the other hand, if you point and click with the same finger, one could
possibly go around this problem, even though it means less precision. On my MT
laptop, I can click at the very edge of the pad without the cursor moving.

> I think we should perform some rudimentary touch tracking to ensure the
> same touch is always used for reporting ABS_X/ABS_Y. A simple distance
> comparison between the two touches, as I implemented in one of my other
> patches, would suffice.


One can certainly decide on the "best" coordinates when putting down the second
finger, as we tried for elantech. However, after some movement, when the second
finger is lifted, chances are you get a jump then instead.

> What do you think?


The general approach we have taken for the kernel is to provide a left button
for both the macbooks and these clickpads, and in addition provide enough
information (read mt data) to solve this problem in userspace. In other words,
one should probably see what additions are needed in the common X drivers to
make the experience a pleasant one.

Thanks,
Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1DURcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:32:00 -0400
Received: from void.printf.net ([89.145.121.20]:53873 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab1DURb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:31:59 -0400
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Aries Lee <arieslee@jmicron.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Fix read-only detection with JMicron 388 chip
References: <s5hoc3zd27i.wl%tiwai@suse.de>
	<m339lba77p.fsf@pullcord.laptop.org> <s5hmxjjil9r.wl%tiwai@suse.de>
Date: Thu, 21 Apr 2011 13:36:03 -0400
In-Reply-To: <s5hmxjjil9r.wl%tiwai@suse.de> (Takashi Iwai's message of "Thu,
	21 Apr 2011 19:09:36 +0200")
Message-ID: <m3y6338q2k.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Thu, Apr 21 2011, Takashi Iwai wrote:
>> I don't like overwriting ops here -- it's too magical, and now we have
>> to maintain the ops table in two places.  A quirk seems justified here,
>> even though we're trying to reduce them in general.
>
> Well, I also used quirk bit in my very first version I worked for
> 2.6.32 kernel.  But when I looked at 2.6.39, quirks are almost full --
> only the last one bit is left for bit 31.  So I didn't want to finish
> it :)
>
>>  Can anyone find a better solution?
>  
> One way would be to copy the ops table itself in struct sdhci_host
> instead of keeping the ops table pointer.  Then you can overwrite only
> the specific op in each probe_slot callback.

I think I'd rather not touch ops at all and keep the code simple --
if you don't mind, please post a version with quirks, and I'll work
on freeing up a few bits.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

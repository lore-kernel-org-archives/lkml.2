Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab0H1QIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:08:53 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:52973 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737Ab0H1QIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:08:51 -0400
Message-ID: <4C79346F.4050409@euromail.se>
Date: Sat, 28 Aug 2010 18:08:15 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] hid: 3m: Correct touchscreen emulation
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se> <1283005748-3293-3-git-send-email-rydberg@euromail.se> <2A410207-8AAA-4D5A-846A-B69F007E6800@enac.fr>
In-Reply-To: <2A410207-8AAA-4D5A-846A-B69F007E6800@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OpNx2-0007fx-4d.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OpNx2-0007fx-4d 2913d83f0bc2a983713a8354c0f09b95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2010 05:56 PM, Stéphane Chatty wrote:

> 
> Le 28 août 10 à 16:29, Henrik Rydberg a écrit :
> 
>> The current code sometimes misses to report the last BTN_TOUCH event
>> when multiple fingers are lifted simultaneously.  With the
>> introduction of MT slots, the tracking id is available to determine
>> the oldest active contact.
> 
> Hi Henrik,
> 
> good job on exploiting the sync quirk!
> 
> About the oldest active contact, I'm not so sure though. I don't have the device
> with me but I remember that 3M recycle IDs, giving the lowest available ID to
> any new finger; this means that the lowest ID is not always the oldest finger.


Hi Stéphane,

I think we use the term tracking id differently here. The HID_DG_CONTACTID is
actually the slot id, and the tracking id is a sequential number, increased
whenever the touch is new. I believe the patchset works correctly as long as
there is less than 32768 new touches before releasing the oldest one. :-)

Cheers,
Henrik

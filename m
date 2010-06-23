Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0FWR2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:28:39 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:49433 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab0FWR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:28:37 -0400
Message-ID: <4C22441D.8000705@euromail.se>
Date: Wed, 23 Jun 2010 19:27:57 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Ping Cheng <pinglinux@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Ping Cheng <pingc@wacom.com>, Benjamin Tissoires <tissoire@cena.fr>,
       Chase Douglas <chase.douglas@canonical.com>,
       Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 2/5] input: Use driver hint to compute the evdev buffer
 size (rev3)
References: <1277291686-7153-1-git-send-email-rydberg@euromail.se> <1277291686-7153-2-git-send-email-rydberg@euromail.se> <1277291686-7153-3-git-send-email-rydberg@euromail.se> <AANLkTilWSe-rdy1johctU6CXdV11Iiw8GkTTQOrsE2aO@mail.gmail.com> <4C223F60.6080904@euromail.se> <20100623171206.GA11512@core.coreip.homeip.net>
In-Reply-To: <20100623171206.GA11512@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1ORTk0-0003eN-9l.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1ORTk0-0003eN-9l ee2047e36988ebd925818413494e2106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Wed, Jun 23, 2010 at 07:07:44PM +0200, Henrik Rydberg wrote:
>> Hi Ping,
>> [...]
>>>> @@ -51,7 +52,9 @@ static DEFINE_MUTEX(evdev_table_mutex);
>>>>
>>>>  static int evdev_compute_buffer_size(struct input_dev *dev)
>>>>  {
>>>> -       return EVDEV_MIN_BUFFER_SIZE;
>>>> +       int nev = dev->hint_events_per_packet * EVDEV_BUF_PACKETS;
>>>> +       nev = max(nev, EVDEV_MIN_BUFFER_SIZE);
>>>> +       return roundup_pow_of_two(nev);
>>> I think we have a backward compatibility issue here. This routine will
>>> return 7 when nev falls to the default value
>>> (EVDEV_MIN_BUFFER_SIZE/64).  This could happen to those drivers that
>>> don't report MT events or forget/don't feel the need to set
>>> hint_events_per_packet since the old BUFFER_SIZE worked perfectly for
>>> them.  We need to keep the return value for those drivers as 64 so we
>>> could allocate the same space as it was in [PATCH 1/5].
>> Are you perhaps confusing EVDEV_BUF_PACKETS and EVDEV_MIN_BUFFER_SIZE? The last
>> line ensures that the value returned is a power of two (hence not 7). The
>> second-to-last line ensures the value is at least equal to 64 (hence not 7). The
>> default hint value for a driver that does not do anything is zero, which leads
>> to a return value of 64, just as it is today.
>>
> 
> I think Ping might have confused roundup_pow_of_two() with
> get_order()-type function...
> 
> Anyways, applied all 5, thanks Henrik.
> 

Got them, thanks to you too.

Henrik


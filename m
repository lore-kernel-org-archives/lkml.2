Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab1LOIZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:25:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60728 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab1LOIZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:25:22 -0500
MIME-Version: 1.0
In-Reply-To: <1323937340.3337.3.camel@jlt3.sipsolutions.net>
References: <1323244922-2673-1-git-send-email-kengyu@canonical.com>
	<CAHR064iBtSTv79BhXt9_mMWugD4U_xLCM4i1wE7PLnZM8pL57g@mail.gmail.com>
	<1323937340.3337.3.camel@jlt3.sipsolutions.net>
Date: Thu, 15 Dec 2011 09:25:20 +0100
Message-ID: <CAHR064ivFUeGwNAfB1MZO0mrvo+sAcM-cZTjR9wZTaPyWRhzAA@mail.gmail.com>
Subject: Re: [PATCH] asus-wmi: explicitly set the wireless LED
From: Corentin Chary <corentin.chary@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Keng-Yu Lin <kengyu@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 9:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-12-15 at 08:07 +0100, Corentin Chary wrote:
>
>> Anyway, you should use a led trigger for that, ideally the rfkill%d
>> led trigger, but for that you need the rfkill idx, which is not
>> exported, so you may need a new rfkill_idx() function. CCing rfkill
>> and led guys, they may have a better advice on that.
>
> Since you wouldn't want to build the string yourself, you'd probably
> want a new rfkill_ledtrigname() function like this:
>
> static const char *rfkill_ledtrigname(struct rfkill *rfkill)
> {
> #ifdef CONFIG_RFKILL_LEDS
>        return rfkill->ledtrigname;
> #endif
>        return NULL;
> }
>
> which you use to assign the LED class device's default trigger.
>
> johannes
>

Right, but is rfkill->ledtrigname really set somewhere ?

rfkill->led_trigger.name seems safer to use.


-- 
Corentin Chary
http://xf.iksaif.net

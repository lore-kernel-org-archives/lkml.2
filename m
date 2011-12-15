Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab1LOIW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:22:26 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:41522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1LOIWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:22:25 -0500
Subject: Re: [PATCH] asus-wmi: explicitly set the wireless LED
From: Johannes Berg <johannes@sipsolutions.net>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Keng-Yu Lin <kengyu@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <CAHR064iBtSTv79BhXt9_mMWugD4U_xLCM4i1wE7PLnZM8pL57g@mail.gmail.com> (sfid-20111215_080747_060859_05239F9D)
References: <1323244922-2673-1-git-send-email-kengyu@canonical.com>
	 <CAHR064iBtSTv79BhXt9_mMWugD4U_xLCM4i1wE7PLnZM8pL57g@mail.gmail.com>
	 (sfid-20111215_080747_060859_05239F9D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 09:22:20 +0100
Message-ID: <1323937340.3337.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 08:07 +0100, Corentin Chary wrote:

> Anyway, you should use a led trigger for that, ideally the rfkill%d
> led trigger, but for that you need the rfkill idx, which is not
> exported, so you may need a new rfkill_idx() function. CCing rfkill
> and led guys, they may have a better advice on that.

Since you wouldn't want to build the string yourself, you'd probably
want a new rfkill_ledtrigname() function like this:

static const char *rfkill_ledtrigname(struct rfkill *rfkill)
{
#ifdef CONFIG_RFKILL_LEDS
	return rfkill->ledtrigname;
#endif
	return NULL;
}

which you use to assign the LED class device's default trigger.

johannes


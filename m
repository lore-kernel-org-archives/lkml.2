Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0IUTv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:51:58 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:34736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab0IUTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:51:57 -0400
Subject: Re: [RFC] led-class: always implement blinking
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1285098497.12764.18.camel@jlt3.sipsolutions.net>
References: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
	 <20100921124419.6b88f7f6.akpm@linux-foundation.org>
	 <1285098497.12764.18.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 21:51:52 +0200
Message-ID: <1285098712.12764.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 21:48 +0200, Johannes Berg wrote:

> Well, this function gets assigned to led_cdev->blink_set(), which is a
> function pointer that takes pass-by-reference arguments. The comment
> there says:
> 
>         /* Activate hardware accelerated blink, delays are in
>          * miliseconds and if none is provided then a sensible default
>          * should be chosen. The call can adjust the timings if it can't
>          * match the values specified exactly. */
>         int             (*blink_set)(struct led_classdev *led_cdev,
>                                      unsigned long *delay_on,
>                                      unsigned long *delay_off);
> 
> but the software implementation doesn't adjust the timings, of course. I
> suppose the "adjust the timings" was also meant to update the values.

But I should update this and the other documentation ... and also
provide a wrapper, because blink_set() is allowed to fail, in which
software fallback should be used.

johannes


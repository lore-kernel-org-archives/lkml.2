Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab1CXArc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:47:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35182 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab1CXAr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTik69v+gdPzwdMSyVnvHMKbWquvfCFvHLmLu-bBB@mail.gmail.com>
References: <AANLkTik69v+gdPzwdMSyVnvHMKbWquvfCFvHLmLu-bBB@mail.gmail.com>
Date: Wed, 23 Mar 2011 17:47:27 -0700
Message-ID: <AANLkTikurVF_-u8gTqM3ireKia28zMrkXRyrvdNTob7e@mail.gmail.com>
Subject: Re: Update on Android PM enhancements - CONFIG_HAS_EARLYSUSPEND and friends
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        devel@linuxdriverproject.org, Naveen Singh <nsingh@atheros.com>,
        Kalle Valo <kvalo@adurom.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Vipin Mehta <vmehta@atheros.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Luis R. Rodriguez <mcgrof@gmail.com>:
> Arve,
>
> What ever happened with your series on the Android PM extensions you
> had submitted in 2009 [1] ? I'm working on ath6kl right now and I'm
> going to remove all that early suspend crap as its not upstream and I
> want to get ath6kl into upstream proper. Do you have plans for a
> replacement?

There is no planned replacement for early suspend, and it will
probably be dropped form the android kernel at some point. The wifi
driver use it to enter a lower operating state when the screen is off.
If you driver does have any other way to put the driver in this state
you need to add an interface that lets user-space select that state
directly.

> Since the thread covers wake locks, have you ironed out
> what you are going to do with that as well?
>

The wakelock code did not get merged. Instead there is a new interface
that should provide the same functionality to drivers, but this has
not integrated with android yet (and you cannot use it directly as it
does not provide the same user-space interface). In theory, you should
be able to replace all the wakelocks in your driver with calls to the
mainline api. Even if you cannot test the result this is better than
just deleting the wakelocks.

-- 
Arve Hjønnevåg

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1EJS5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:57:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56225 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1EJS53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=d/s4rpea5tuT4iViid4fcWBbH86ZMgrS6wa4mrFjsZXtct74itgJGcY2WA77lNCJAa
         sb7rC8Ro8HqDtQ9bAGJQT8MQ/7bCBAOSIUeRhmN/GUwRPbGfsDDN48+N+//P9fqdsCkM
         1h6Ox0YfytdzMaQ9lNWnbjB9HhObWSQfNu3oY=
MIME-Version: 1.0
In-Reply-To: <BANLkTin=cU_kCSFfznna69pkgTsSNVjJgw@mail.gmail.com>
References: <BANLkTin=cU_kCSFfznna69pkgTsSNVjJgw@mail.gmail.com>
Date: Tue, 10 May 2011 20:57:28 +0200
Message-ID: <BANLkTi=Lo4jRWbHhMLkJmOfg09s+ebDjcw@mail.gmail.com>
Subject: [hrtimers] Re: Regression affecting b43 LP-PHY card
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: b43-dev <b43-dev@lists.infradead.org>, linux-wireless@vger.kernel.org,
        Juan Carlos Romero <juancarlos.romero@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ben Greear <greearb@candelatech.com>,
        John Stultz <john.stultz@linaro.org>,
        Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 10 maja 2011 00:52 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> Juan owns Lenovo affected by well-known LP-PHY DMA errors. His testing
> procedure is following:
> modprobe wl; connect; download sth small; rmmod wl;
> modprobe b43; download 2GB
>
> When working on DMA errors we discovered that wireless-testing is not
> working well for him. Even after performing above procedure his
> machine disconnects quickly and he is not able to reconnect. We tested
> 2.6.39-rc6 from tarball and it was working fine. I'd like to highlight
> here, that we were switching between mainline and wireless-testing few
> times. It is not a random issue.
>
> I suspected this regression could be caused by my recent ssb patches.
> So I reverted all of them but this didn't help.
>
> In this situation we decided to bisect. I was a little afraid of last
> merges so we took older 2.6.38 as GOOD (we tested this twice) and
> wireless-testing commit before my ssb changes as BAD. Today Juan
> finished bisecting kernel:
> http://pastebin.com/HSKbRzpB
>
> According to his bisection the first bad commit is
> e06383db9ec591696a06654257474b85bac1f8cb [0]:
> hrtimers: extend hrtimer base code to handle more then 2 clockids
>
> Does it make any sense to you? Could this be some timing issue?
>
> It was too late to test this today, we (Juan) will work on this
> tomorrow. It's impossible to revert this commit from HEAD of
> wireless-testing, so my idea is to checkout commit, test, revert,
> test.
>
> Did anyone else experience any similar problems with latest wireless-testing?
>
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e06383db9ec591696a06654257474b85bac1f8cb

Today Juan checkouted commit e06383db9ec591696a06654257474b85bac1f8cb
and tested it. He was disconnected really soon.

Then he reverted e06383db9ec591696a06654257474b85bac1f8cb and tested
again. Connection was stable, he downloaded 2GB file over network.


John S.: your commit does not touch Broadcom card directly, but it
seems it somehow affects it. I suspect there can be some timing issue.
Do you have any idea what could it be, how can we debug this?

-- 
Rafał

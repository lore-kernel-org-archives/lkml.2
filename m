Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1KZVy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 16:54:59 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56920 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab1KZVy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 16:54:57 -0500
MIME-Version: 1.0
In-Reply-To: <201111262232.46195.rjw@sisk.pl>
References: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com>
	<201111250203.29786.rjw@sisk.pl>
	<201111262232.46195.rjw@sisk.pl>
Date: Sun, 27 Nov 2011 05:54:56 +0800
X-Google-Sender-Auth: gLFPa9wGDqc_CRMU7DaQ6utde6Y
Message-ID: <CAJ-VmonZYrEJS7UkqdSTnMQ5waDjPgSpVDPqiHz2=Uksso5tHw@mail.gmail.com>
Subject: Re: [Regression, 3.2-rc1] ath9k broken on AR928X (was: Re: Linux
 3.2-rc3 - just in time for Thanksgiving)
From: Adrian Chadd <adrian@freebsd.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2011 05:32, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> Tomorrow I'll try to identify the offending commits.
>
> Well, it took more time than I had hoped. :-(
>
> Bisection turns up:
>
> commit 2577c6e8f2320f1d2f09be122efef5b9118efee4
> Author: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> Date:   Tue Sep 13 22:38:18 2011 +0530
>
>    ath9k_hw: Add support for AR946/8x chipsets.
>
>    This patch adds support for AR946/8x chipets.

Oh god. That's going to be fun to figure out :)

> which I think is wrong for at lest two reasons.  Not that I understand
> what it actually does to the driver, but first, it does much more than the
> changelog says and, second, it is practically impossible to revert
> because of the number of commits on top depending on it.  Quite frankly,
> it is about to make it to my list of examples of how things should _not_ be
> done in the kernel.
>
> The commit immediately preceding it doesn't show any symptoms of failure, so
> I'm quite convinced this one really introduced the problem for me.
>
> The chip in the affected box is (according to "lspci -v"):

Can you please find out what the actual PCI device id is? That way I
can help you (hopefully) isolate which bits of that change would cause
your regression.

That commit almost exclusively touches the AR93xx chipset support, so
I can't (easily) see how this would break support for the AR928x NICs.

Adrian

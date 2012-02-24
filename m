Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2BXMyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:54:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab2BXMyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:54:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH v5 4/5] Extcon: support mutually exclusive relation between cables.
Date: Fri, 24 Feb 2012 12:53:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, gregkh@linuxfoundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com> <201202221000.00810.arnd@arndb.de> <CAJ0PZbR+AEpfNcX0wMHdVQfseC+fMxJjyaM25378miLnnfV0+w@mail.gmail.com>
In-Reply-To: <CAJ0PZbR+AEpfNcX0wMHdVQfseC+fMxJjyaM25378miLnnfV0+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202241253.52336.arnd@arndb.de>
X-Provags-ID: V02:K0:J72Bs3fZLFXI0yJkVpbs+AWhFPQ+e9A1MxRkbB3q3qJ
 2TkmIhlfB7pTli2z5SCfT3VCG/tyVTuaYvgfkhF0bCcy2cWC/L
 KJfv46ZHZnNyodjM9n5tuCJI8v97Uz7ut5XTtX32YbrXEWTB6i
 dQkSZV3LBIj/1PylPJdRAt5M8xOFreK7LUE945zx83DApRghoL
 PvLgJ+UIdLSEJ1tTngdqg5zn7msSe53MvAA1Zdl039jJZ8DOt4
 0r4Ns8ERKz/JBaVmG6THh1MxLBkYpcQccfi85Vf6s+qiu8vZhM
 D52aYyim0ll1XdW3ilqBqNMit29UpdX34ixToQ7FkA7AIyIzml
 PRzFhX+mIU60kKi+h5WI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 February 2012, MyungJoo Ham wrote:
> Ok, here goes an example how it would look like in the next revision of Extcon.
> I think this addresses your comments on multistate-support patch (3/5)
> 
> /sys/class/extcon/max8997-muic.0/
>         name: "max8997-muic.0"
>         state: 0x00000009                   /* RW. 0xblahblah format
> for both read and write */
>         mutually_exclusive/
>                 rule.0: 0x3
>                 rule.1: 0x5
>                 rule.2: 0xC
>         cable.0/
>                 name: "VGA"
>                 state: 1            /* RW: 0 or 1 */
>                 mutually_exclusive/
>                         cable.1
>                         cable.2
>         cable.1/
>           ...
> 
> 
> How about this?
> 

I would leave out the global mutually_exclusive/ directory because that
is redundant and I see no benefit in it. Having the redundant "state"
files is probably a good idea because the global one lets you make
atomic changes of multiple cables and the other are very convenient.

What kind of object is /sys/class/extcon/max8997-muic.0/cable.0/mutually_exclusive?
Is that a file with two lines, a directory with two empty files or
a directory with symlinks to the other directories?

	Arnd

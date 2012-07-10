Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab2GJM4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:56:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43918 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2GJM4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:56:09 -0400
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20120709203929.GC17301@burratino>
References: <20120614162609.4613.22122.reportbug@henna.lan>
	<20120614215359.GF3537@burratino>
	<CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com>
	<20120616044137.GB4076@burratino>
	<1339932233.20497.14.camel@henna.lan>
	<CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com>
	<4FF9CA30.9050105@redhat.com>
	<CAPZXPQd026xfKrAU0D7CLQGbdAs8U01u5vsHp+5-wbVofAwdqQ@mail.gmail.com>
	<4FFAD8D9.8070203@redhat.com>
	<20120709203929.GC17301@burratino>
Date: Tue, 10 Jul 2012 15:56:08 +0300
X-Google-Sender-Auth: _q1rHnH2PI8XMTKCJVYUyEychYE
Message-ID: <CAPZXPQcaEzW1zGXfGwp-JuOrfBu2xhoidaYjthD8jhYAFpWr7A@mail.gmail.com>
Subject: Re: video: USB webcam fails since kernel 3.2
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
        =?UTF-8?Q?Jean=2DFran=C3=A7ois_Moine?= <moinejf@free.fr>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Thank you for these detailed instructions. Find the results of my testing below:

2012/7/9 Jonathan Nieder <jrnieder@gmail.com>:
> Hans de Goede wrote:
>
>> Erm, that is quite a bit of work from my side for something which you
>> can easily do yourself, edit gspca.c, search for which_bandwidth
>> and then under the following lines:
>>         u32 bandwidth;
>>         int i;
>>
>> Add a line like this:
>>       return 2000 * 2000 * 120;
>
> In case it helps, here are some more complete instructions.
>
>  0. Prerequisites:
>
>         apt-get install git build-essential
>
>  1. Get the kernel history, if you don't already have it:
>
>         git clone \
>           git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Cloned up to the following commit:

commit 2437fccfbfc83bcb868ccc7fdfe2b5310bf07835
Merge: 6c6ee53 d92d95b6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jul 9 13:43:02 2012 -0700

    Merge tag 'regulator-3.5' of
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator

>  2. Try linus's master:
>
>         cd linux
>         git fetch origin
>         git reset --hard origin/master
>         cp /boot/config-$(uname -r) .config; # current configuration
>         scripts/config --disable DEBUG_INFO
>         make localmodconfig; # optional: minimize configuration
>         make deb-pkg; # optionally with -j<num> for parallel build
>         dpkg -i ../<name of package>; # as root
>         reboot
>         ... test test test ...
>
>     Hopefully it reproduces the bug.

Fails as previously.

>  3. Try Hans's first suggested change, as described in the quoted text
>     above:

/* compute the minimum bandwidth for the current transfer */
static u32 which_bandwidth(struct gspca_dev *gspca_dev)
{
        u32 bandwidth;
        int i;

        return 2000 * 2000 * 120;

        /* get the (max) image size */

>         cd linux
>         vi drivers/media/video/gspca/gspca.c
>         ... make the suggested edits ...
>         make deb-pkg; # maybe with -j4
>         dpkg -i ../<name of package>; # as root
>         reboot
>         ... test test test ...

The camera works again in Cheese, at least some of the time. Other
times, launching Cheese immediately crashes GNOME, which restarts the
X.org server.

However, with Skype 4.0.0.7, it only shows a green square, instead of
the camera's output.

>  4. Try Hans's second suggested change, as described in a previous
>     message:
>
>         cd linux
>         vi drivers/media/video/gspca/gspca.c
>         ... make the suggested edits ...
>         make deb-pkg; # maybe with -j4
>         dpkg -i ../<name of package>; # as root
>         reboot
>         ... test test test ...

This produces a severely distorted image for a few seconds, then
Cheese crashes; GNOME itself survives.

Meanwhile, Skype 4.0.0.7 shows a black square, instead of the camera's output.

I hope that the above already provides some usable answers.

Martin-Éric

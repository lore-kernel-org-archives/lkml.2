Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2EUMxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:53:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43761 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2EUMxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAFub=KS1_Bj=b2OVTf33VHtQ7BKY2k3Wd1oGwmVVJNgbexZ=6w@mail.gmail.com>
References: <CAFub=KS1_Bj=b2OVTf33VHtQ7BKY2k3Wd1oGwmVVJNgbexZ=6w@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 21 May 2012 05:52:55 -0700
X-Google-Sender-Auth: INKAz3Ye16ffQAHIo0_IzdNYoSA
Message-ID: <CAB=NE6VFghHT6zvGfW+9-Vsik39A_4Df=U3J1OtFFpM8LKDzvw@mail.gmail.com>
Subject: Re: [Lf_driver_backport] scripts in compat tree
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Cc: lf_driver_backport@lists.linux-foundation.org,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 5:32 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Hi,
>
> I will be working on the GSoC project to prepare compat graphics drivers.
>
> Looking at the scripts (ckmake and get-compat-kernels) in the compat tree, I
> see that they are only handling Ubuntu systems. First of all, should they
> really be distro-aware?

When I wrote this I posted the patch to lkml [0] for wider review and
naturally I got the same reaction from folks. I wrote it originally
with the goal to do something distro-agnostic and in fact it is, its
just that I haven't figured out a quick way to make this work across
the board.

[0] https://lkml.org/lkml/2012/2/7/501

More below.

> Why not to download the tarballs from kernel.org?
> Isn't it a more generic approach?

Well kernel.org does not have already built kernels. Ubuntu's PPA
kernels *are* vanilla kernels, in fact that is why they were put up,
they are guaranteed to be built on vanilla kernels. We couldn't get a
more generic approach then. The only thing though is -- the PPA
kernels obviously have the kernels integrated on .debs. There are a
few options here:

  1) If Ubuntu can dpkg -x the kernels for us onto tarballs that'd be swell
  2) We could write our own script to do this with C code that does
the dpkg -x for us

There are ways to do 2) suggested in the thread above.

> If this makes sense, I'd like to extend those scripts to handle vanilla
> kernels with a cmdline switch which won't care at all about lsb_release. I
> will hardcode end-of-life products and parse kernel.org to dynamically
> detect new versions, download and extract them under /lib/modules if they
> don't exist in there, etc.

That'd be amazing!

> I'm waiting for your feedback :)

Thanks!

  Luis

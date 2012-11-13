Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2KMJLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:11:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2KMJLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:11:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <rob.clark@linaro.org>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Date: Tue, 13 Nov 2012 09:11:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org> <20121112235348.GD28341@n2100.arm.linux.org.uk> <CAF6AEGvoXR3YJomjV1YOeNvjr46aYJ2mVxS+jZfH+41+v1nAvw@mail.gmail.com>
In-Reply-To: <CAF6AEGvoXR3YJomjV1YOeNvjr46aYJ2mVxS+jZfH+41+v1nAvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211130911.09613.arnd@arndb.de>
X-Provags-ID: V02:K0:YiZ1o/rPZz6v7UopDqCyTb6r4WPbrJwIcQTjnLwdSkg
 KliNWxLApIggDAUSM6RExoINWKDcrWMSyRNO9ImRJ5KURP/BjZ
 LxOyPG7hVsDOCv7iJ1JNbY4oZNwskwFjH2Z78wg3h7vfZY3yCo
 YoPnNo8gL1XPwbdTs5IVhFTzBiXGn0CMsBzcy9YJqsD4ovn8Iy
 v2g/l5a5mg7Uq9sFI9oz3rZGjIcxJGWv6H1vxk9T3YezHau6ac
 d1hw7yd5P0NM9IjLEGsPEUNRJIE9NYynG/X190S2mjbv/UxdE4
 4ecdnW+qzuZPJGrrl9tbSgWY/7OEdkZiIEBKj4HaSql2lwtZXA
 zf4NT/rR4d9up1amimdk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012, Rob Clark wrote:
> right, that is what I was worried about..  but what about something
> along the lines of:
> 
>                 case 8: {                                               \
>                         if (sizeof(x) < 8)                              \
>                                 __get_user_x(__r2, __p, __e, __l, 4);   \
>                         else                                            \
>                                 __get_user_x(__r2, __p, __e, __l, 8);   \
>                         break;                                          \
>                 }                                                       \

I guess that's still broken if x is 8 or 16 bits wide.

> maybe we need a special variant of __get_user_8() instead to get the
> right 32bits on big vs little endian systems, but I think something
> roughly along these lines could work.
> 
> Or maybe in sizeof(x)<8 case, we just __get_user_bad()..  I'm not 100%
> sure on whether this is supposed to be treated as an error case at
> compile time or not.

We know that nobody is using that at the moment, so we could define
it to be a compile-time error.

But I still think this is a pointless exercise, a number of people have
concluded independently that it's not worth trying to come up with a
solution, whether one exists or not. Why can't you just use copy_from_user()
anyway?

	Arnd

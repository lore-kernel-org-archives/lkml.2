Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab0GVTTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:19:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62310 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab0GVTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HRFMPlS6eiILz9mLUFmsOW/pmUYjKF2GGHB1MR6Z7FIqb3/D1GanRzkSXRj9IO/9Bv
         87Hpaht1fiYm5qP8UpjU3amdu8eaHlN7VyUnnBhf68meXgf0dXhnrfIhTIZ2auKCZwwB
         Z+l8ZsbjiSmSrLxhcJyVnSQohZ/BJQ/Xr8DZY=
MIME-Version: 1.0
In-Reply-To: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
Date: Thu, 22 Jul 2010 21:19:25 +0200
Message-ID: <AANLkTinxNlCSBqBggTIlVqyyn4NLy4LbZU8SFAlqPLow@mail.gmail.com>
Subject: Re: Introducing the LCD-Linux project
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Mattia Jona-Lasinio <mattia.jona@gmail.com>
Cc: linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <triad@df.lth.se>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, ivan.kuten@promwad.com,
        lcd-linux-users@lists.sourceforge.net,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 2:57 PM, Mattia Jona-Lasinio
<mattia.jona@gmail.com> wrote:
> Hi,
>
> this is to introduce the LCD-Linux project (http://lcd-linux.sourceforge.net/),
> a kernel level implementation of a VT102 terminal emulator, optimized for small
> alphanumeric and graphic displays.
>
> The possibility to connect to the computer small alphanumeric as well as graphic
> displays, has always attracted some interest. These small devices are connected
> to the computer and can be used to display system diagnostics like network
> usage, RAM or disk usage or even to replace the usual monitor. Possible
> applications can be found in embedded systems or clusters. These displays are
> connected to the computer through serial lines, parallel ports and more recently
> through USB connections. Appropriate programs in userspace gather the desired
> information and output it on the display. However for this to work, the
> userspace program has to implement some sort of display management, to determine
> what must be displayed where. This has two major disadvantages. First. Every
> userspace program willing to drive a display must solve the very same problems
> (display scroll and refresh, for instance), resulting in an overall duplication
> of code. Second. Display controllers usually require quite strict timings for
> proper operation and it is not trivial neither efficient to obtain this in
> userspace, whereas it is straightforward in kernel space through the usual delay
> functions. A solution is therefore to provide a sort of minimal terminal
> emulation in kernel space, that can be accessed through the standard character
> device interface. In this way the problem of the display management is reduced
> to some calls to the usual read/write/seek/ioctl routines. At the same time one
> has the possibility to implement handling of escape sequences, thus opening the
> way to standard applications based on the ncurses library.

Someone told me once ago, when I submitted the cfag12864b/ks0108
drivers, to make them use a framebuffer, so we could get a console on
it using a program like con2fb program in an independent manner. It
worked flawlessly and the console was quite usable!

I see that you want to implement something more complex, but maybe
someone/you can make a use of that idea. Check it out : )

>
> LCD-Linux aims to be a complete VT102 terminal emulation in kernel space,
> optimized for small alphanumeric and graphic displays. It consists of two
> distinct pieces of software.
>
> The first piece is the lcd-linux module in itself, implementing a (hopefully)
> complete VT102 terminal with the addition of some custom escape sequences
> specific to the world of small LCD displays. Care has been taken to avoid any
> conflict between standard and custom escape sequences. A major feature of
> lcd-linux is the possibility to define a virtual display geometry larger than
> the physical one, so that one can use a small display as a normal 80x25 monitor
> in an effective way. The layer takes care about display refresh and keeps the
> cursor visible in a smart way. A second feature is the possibility to connect
> more than one display (up to 256 different displays). Each display is assigned a
> different minor number and is addressed individually. The lcd-linux module also
> registers the appropriate major number character device and implements all the
> relevant read/write/seek/ioctl functions allowed on the character device.
> Finally it creates some /proc files for internal inspection, information and
> diagnostics.
>
> The second piece of software is the display driver, implementing all functions
> that are controller specific. Each driver registers itself with the lcd-linux
> layer and behaves like a 'slave' with respect to it. The interface between
> lcd-linux and the display driver is kept as simple as possible and no assumption
> is made by any of the two parts on the implementation of the other part. Ideally
> there will be one module for each controller. At the current stage, the driver
> for the Hitachi HD44780 (and compatibles) controller is fully implemented and
> optimized. Drivers for other controllers can be written in an easy way thanks to
> the standard interface provided by the lcd-linux layer.
>
> The LCD-Linux project has been under development for several years and has now
> reached a stable state. It has been succesfully compiled, tested and used on
> different machines running Linux version 2.2, 2.4 and 2.6. The software can be
> compiled as a module or compiled statically into the kernel. In the latter case,
> the user can pass some parameters at boot time, to configure the display as soon
> as possible during the boot sequence. The project comes with Documentation and
> examples about how to use it.
>
> LCD-Linux is released under the GNU General Public License version 2. The latest
> release is available at the Sourceforge website:
>
> http://lcd-linux.sourceforge.net/
> http://prdownloads.sourceforge.net/lcd-linux/lcd-linux-0.13.9.tar.gz?download
>
> The CVS version still includes some partial support for Linux 2.0 but this
> support is considered obsolete and now abandoned in the official release.
>
> The LCD4Linux (http://ssl.bulix.org/projects/lcd4linux/) project is known to
> support LCD-Linux among the possible connection types.
>
> I would appreciate some comments and feedback on the project. In view of the
> potential applications, future developments and improvements of LCD-Linux, I
> would also like to propose LCD-Linux for inclusion in the Linux kernel mainline.
>
> Thank you for your attention.
>
> With best regards,
>
> Mattia Jona-Lasinio
>
> (LCD-Linux project developer and maintainer)
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab2HLP3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 11:29:05 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34452 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751077Ab2HLP3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 11:29:02 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+R19YGy0ORB9uxcn4GX4Io0EYiGKyA/x8mmW2n4H
	/jvIKtXIILdeGE
Message-ID: <5027CBB8.7030201@gmx.de>
Date: Sun, 12 Aug 2012 15:28:56 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@googlemail.com>
CC: linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 00/11] fblog: Framebuffer kernel log driver v4
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
In-Reply-To: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2012 02:53 PM, David Herrmann wrote:
> Hi
> 
> This is revision 4 of the fblog driver. It is a replacement for fbcon for
> systems that do not want/need CONFIG_VT. It simply prints the kernel-log to all
> connected framebuffers. Previous versions are available here:
>   v3: http://thread.gmane.org/gmane.linux.kernel/1328164
>   v2: http://thread.gmane.org/gmane.linux.serial/8133
>   v1: http://marc.info/?l=linux-kernel&m=133988465602225&w=2
> 
> This patchset is based on linux-next.
> 
> Changes from previous version:
>   - Changed mailinglist to linux-fbdev instead of linux-serial
>   - Added "main_only" and "activate_on_hotplug" module parameters to provide
>     more fine-grained control over which framebuffers are used
> 
> As always simply remove the !VT dependency if you want to test this with VTs
> enabled. Some more background information on deprecating CONFIG_VT can be found
> here:
>   http://dvdhrm.wordpress.com/2012/08/12/killing-off-config_vt/
> 
> I am still looking for someone who is willing to push this to linux-next through
> his or her tree. Feedback is much appreciated!

I'll take care of this. But I'm currently very busy writing a thesis, so
it could take some time. It would be great if someone would find time to
give this a complete thorough review.


Thanks,

Florian Tobias Schandinat

> 
> Thanks
> David
> 
> David Herrmann (11):
>   fbcon: move update_attr() into separate source file
>   fbcon: move bit_putcs() into separate source file
>   fblog: new framebuffer kernel log dummy driver
>   fbdev: export get_fb_info()/put_fb_info()
>   fblog: register one fblog object per framebuffer
>   fblog: open fb on registration
>   fblog: allow selecting fbs via sysfs and module-parameters
>   fblog: cache framebuffer BLANK and SUSPEND states
>   fblog: register console driver
>   fblog: draw console to framebuffers
>   MAINTAINERS: add fblog entry
> 
>  MAINTAINERS                     |   6 +
>  drivers/video/Kconfig           |   5 +-
>  drivers/video/Makefile          |   2 +-
>  drivers/video/console/Kconfig   |  37 ++-
>  drivers/video/console/Makefile  |   4 +-
>  drivers/video/console/bitblit.c | 149 +--------
>  drivers/video/console/fbcon.h   |   5 +-
>  drivers/video/console/fbdraw.c  | 171 ++++++++++
>  drivers/video/console/fbdraw.h  |  30 ++
>  drivers/video/console/fblog.c   | 691 ++++++++++++++++++++++++++++++++++++++++
>  drivers/video/fbmem.c           |   6 +-
>  include/linux/fb.h              |   3 +
>  12 files changed, 951 insertions(+), 158 deletions(-)
>  create mode 100644 drivers/video/console/fbdraw.c
>  create mode 100644 drivers/video/console/fbdraw.h
>  create mode 100644 drivers/video/console/fblog.c
> 


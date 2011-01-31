Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1AaRuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:50:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:34379 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab1AaRuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:50:20 -0500
Date: Mon, 31 Jan 2011 09:46:22 -0800
From: Greg KH <gregkh@suse.de>
To: Arthur Taylor <art@ified.ca>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, alan@redhat.com,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] vt: Add virtual console keyboard mode OFF
Message-ID: <20110131174622.GA25097@suse.de>
References: <AANLkTikZe1EuvNQHceNUdKFpmmeAbQG8H+34AG9fw43u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikZe1EuvNQHceNUdKFpmmeAbQG8H+34AG9fw43u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 12:36:22AM -0800, Arthur Taylor wrote:
> Add a new mode for the virtual console keyboard OFF to compliment RAW
> in which all key events are ignored. New mode prevents vt input
> buffers from overflowing when a program opens but doesn't read from a
> tty, like Xorg using only evdev for input.
> 
> The new mode is available by the ioctl KDSKBMODE with argument K_OFF
> from linux/kd.h. Does not effect sysrq behaviour.

Care to document this somewhere (i.e. Documentation/ABI?)

> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alan Cox <alan@redhat.com>
> Signed-off-by: Arthur Taylor <art@ified.ca>
> ---
>  drivers/tty/vt/keyboard.c |    5 +++--
>  drivers/tty/vt/vt_ioctl.c |    3 +++
>  include/linux/kbd_kern.h  |    3 ++-
>  include/linux/kd.h        |    1 +
>  4 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
> index e95d787..6dd3c68 100644
> --- a/drivers/tty/vt/keyboard.c
> +++ b/drivers/tty/vt/keyboard.c
> @@ -654,7 +654,8 @@ static void k_spec(struct vc_data *vc, unsigned
> char value, char up_flag)

Your patch is line-wrapped and can not be applied :(

> @@ -50,11 +50,12 @@ struct kbd_struct {
>  #define VC_CAPSLOCK	2	/* capslock mode */
>  #define VC_KANALOCK	3	/* kanalock mode */
> 
> -	unsigned char kbdmode:2;	/* one 2-bit value */
> +	unsigned char kbdmode:3;	/* one 3-bit value */

Are you sure you can change the size of this structure and no one is
going to have problems?

Also, what userspace code is going to use this new feature?  Has it been
tested to work properly?

thanks,

greg k-h

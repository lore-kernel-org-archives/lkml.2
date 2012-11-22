Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030271Ab2KVT5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:57:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49363 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab2KVT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:57:29 -0500
Date: Thu, 22 Nov 2012 11:58:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: devel@driverdev.osuosl.org, Markus Grabner <grabner@icg.tugraz.at>,
        line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        laurent_navet@yahoo.com
Subject: Re: [PATCH 00/46] staging: line6: drop MIDI state sysfs attrs
Message-ID: <20121122195840.GA26543@kroah.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 08:48:39PM +0100, Stefan Hajnoczi wrote:
> Let's put the line6 staging driver on a diet for Thanksgiving! :)

Yeah!

> Markus and I have discussed the MIDI processing that currently happens in the
> line6 driver.  This stuff really belongs in userspace where a library or
> utility can use ALSA MIDI APIs to control the device.  Moving MIDI processing
> to userspace has several benefits:
> 
> 1. The driver only handles PCM and MIDI I/O.  This means less kernel code.
> 
> 2. A large number of sysfs attributes can be removed.  These attributes exposed
>    MIDI state and driver code was necessary to sync and manage this state.
> 
> 3. It's easier for userspace to control the device, try out new MIDI commands,
>    etc when the driver acts as a dumb transport.
> 
> This patch series removes the sysfs attributes and then removes the state
> behind those attributes.  I have tried to make small incremental changes that
> can be reviewed easily.

Very nice, I'll queue these up on Monday, very good work, thanks so much
for doing this.

>  drivers/staging/line6/Kconfig       |  11 -
>  drivers/staging/line6/Makefile      |   2 -
>  drivers/staging/line6/control.c     | 995 ------------------------------------
>  drivers/staging/line6/control.h     | 195 -------
>  drivers/staging/line6/driver.c      |  20 -
>  drivers/staging/line6/dumprequest.c | 135 -----
>  drivers/staging/line6/dumprequest.h |  76 ---
>  drivers/staging/line6/midi.c        | 120 -----
>  drivers/staging/line6/midi.h        |  10 -
>  drivers/staging/line6/pod.c         | 846 +-----------------------------
>  drivers/staging/line6/pod.h         | 105 +---
>  drivers/staging/line6/variax.c      | 480 +----------------
>  drivers/staging/line6/variax.h      |  60 ---
>  13 files changed, 16 insertions(+), 3039 deletions(-)
>  delete mode 100644 drivers/staging/line6/control.c
>  delete mode 100644 drivers/staging/line6/control.h
>  delete mode 100644 drivers/staging/line6/dumprequest.c
>  delete mode 100644 drivers/staging/line6/dumprequest.h

I like seeing diffstats like that :)

greg k-h

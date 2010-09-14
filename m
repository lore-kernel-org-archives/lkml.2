Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0INTXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:23:04 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:15799 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0INTXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:23:02 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz1432N98dNef8Kzz1202hzz8275bh8275dhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Tue, 14 Sep 2010 14:22:36 -0500
From: Scott Wood <scottwood@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Timur Tabi <timur@freescale.com>, amit.shah@redhat.com,
        linuxppc-dev@ozlabs.org, kumar.gala@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hvc_console: fix dropping of characters when output
 byte channel is full
Message-ID: <20100914142236.64547ec3@schlenkerla.am.freescale.net>
In-Reply-To: <20100914121721.c8671ed8.akpm@linux-foundation.org>
References: <1282329921-24394-1-git-send-email-timur@freescale.com>
	<20100914121721.c8671ed8.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2010 19:22:37.0912 (UTC) FILETIME=[3122A580:01CB5442]
X-Reverse-DNS: az33egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 12:17:21 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 20 Aug 2010 13:45:21 -0500
> Timur Tabi <timur@freescale.com> wrote:
> 
> > hvc_console_print() calls the HVC client driver's put_chars() callback
> > to write some characters to the console.  If the callback returns 0, that
> > indicates that no characters were written (perhaps the output buffer is
> > full), but hvc_console_print() treats that as an error and discards the
> > rest of the buffer.
> > 
> > So change hvc_console_print() to just loop and call put_chars() again if it
> > returns a 0 return code.
> 
> Seems rather dangerous.  The upper layer will sit there chewing 100%
> CPU for as long as the lower layer is congested.

This is just for printk(), not user output.  This is exactly what
printk() has always done for real serial ports.

> > This change makes hvc_console_print() behave more like hvc_push(), which
> > does check for a 0 return code and re-schedules itself.
> 
> Yes, hvc_push() reschedules.

hvc_push() is not relevant to kernel console output.

hvc_console_write() currently does not reschedule anything.  It just
drops characters when busy.

-Scott


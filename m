Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0DTD0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:26:16 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58595 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab0DTD0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:26:15 -0400
X-Greylist: delayed 3712 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 23:26:15 EDT
Date: Mon, 19 Apr 2010 19:21:10 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if
	CONFIG_VGA_CONSOLE is undefined
Message-ID: <20100420022110.GA20116@ericsson.com>
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com> <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com> <1270491029.1477.453.camel@groeck-laptop> <4BBA3021.9090504@zytor.com> <1270497725.1477.488.camel@groeck-laptop> <4BBA473D.9040004@zytor.com> <1270501481.1477.521.camel@groeck-laptop> <4BBA51F3.7070808@zytor.com> <1270505579.1477.584.camel@groeck-laptop> <4BCCC4E1.8040109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BCCC4E1.8040109@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 05:02:25PM -0400, H. Peter Anvin wrote:
> Hi Guenter,
> 
> I wanted to check where we are at... at the very least we should drop
> messages issued before initialization when isVGA != 1.
> 
> Since serial ports require initialization, I really don't want to send
> messages to the serial port before the port has been initialized, but
> obviously it would be good to initialize earlyprintk as early as at all
> possible.
> 
Moving setup_early_printk() around may be possible, but I do not know
the code good enough to take that risk. Even trying was a bad idea.

I could submit a patch to add some protection into early_printk(),
to ensure it does not write into VGA memory space if there is no VGA,
and do that without changing current semantics - specifically, still
write into VGA memory space even if setup_early_printk() was not called
yet, but if boot_params.screen_info.orig_video_isVGA is set.

I thought you indicated that you are opposed to changing the code,
and it looks kind of clumsy, so I concluded that it was not worth
trying again. Maybe I misunderstood - let me know.

Guenter

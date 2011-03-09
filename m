Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab1CIRV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:21:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1CIRV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:21:56 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=Qq7vIXD-ciIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=MPTHcUjWaX_8BA51xnQA:9 a=jYkJuiYJgoTojMnMVfUK3A7-l8YA:4 a=PUjeQqilurYA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95
From: Steven Rostedt <rostedt@goodmis.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <gregkh@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org
In-Reply-To: <s5hfwqwnt9s.wl%tiwai@suse.de>
References: <1299685189.15854.182.camel@gandalf.stny.rr.com>
	 <20110309155309.GA30598@suse.de>
	 <1299687658.15854.227.camel@gandalf.stny.rr.com>
	 <s5hfwqwnt9s.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 12:21:53 -0500
Message-ID: <1299691313.15854.267.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 17:38 +0100, Takashi Iwai wrote:

> Could you try the patch below?  Totally untested.

It seems to work. I added the patch and the warning is gone, and removed
it, and it reappeared. Now, I don't have and speakers attached to this
test box, so I never tested if sound works ;)

> 
> 
> Takashi
> 
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] sound: Use sound_register_*() for additional OSS minor devices
> 
> Since OSS driver creates the device entries for /dev/audio* and
> /dev/dspW* by itself without coping with sound_core, it leads to
> conflicts with others and let sysfs spewing warnings.
> 
> This patch rewrites the registration part of OSS driver to use
> the standard method also for additional minor devices.

Reported-by: Steven Rostedt <rostedt@goodmis.org> (with ktest.pl)
Tested-by: Steven Rostedt <rostedt@goodmis.org> (with ktest.pl)

-- Steve

> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---



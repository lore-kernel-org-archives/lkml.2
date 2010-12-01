Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0LAOde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:33:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44629 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab0LAOdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:33:32 -0500
Date: Wed, 1 Dec 2010 15:33:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101201143329.GB18074@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tobias Karnat <tobias.karnat@googlemail.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1291201307.3029.21.camel@Tobias-Karnat>
 <20101201123921.GA15530@a1.tnic>
 <1291209888.12511.11.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1291209888.12511.11.camel@Tobias-Karnat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 02:24:48PM +0100, Tobias Karnat wrote:
> > What does that mean? Are you using an official kernel version or
> > something you cooked up?
> 
> I'm using the official 2.6.36.1 kernel.
> The problem happens with the modules from the kernel 2.6.36.1
> 
> But as a workaround for now,
> I'm using the edac modules from 2.6.35 compiled for 2.6.36.1
> I'm just saying that the problem only occurs on kernel >= 2.6.36

Hmm, I can't reproduce it here.

> > Please try to catch the whole oops. I can see rIP but it'd be much more
> > helpful to see the calltrace and the whole register dump which are cut
> > off at the bottom of your pic.
> 
> Yes, here you go:
> 
> http://i55.tinypic.com/igyhpt.jpg

Unfortunately, this is still incomplete because it is missing the Code: tag and
the end trace tag which looks like this

---[ end trace ... ]---

and this is most probably so because we're halting and cannot print out
all the oops. Two things you can do:

1. Connect the machine to another machine over serial- or netconsole.
Google for instructions how.

2. If you can't do 1. you can try enabling CONFIG_BOOT_PRINTK_DELAY and
boot the kernel with 'boot_delay=10', for example, so that a 10ms delay
is inserted after each printk line. This might let us see more on the
console before halt and catch the whole oops.

Thanks.

-- 
Regards/Gruss,
Boris.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0LBG6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 01:58:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55877 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0LBG6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 01:58:47 -0500
Date: Wed, 1 Dec 2010 20:35:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101201193508.GA4916@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tobias Karnat <tobias.karnat@googlemail.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1291201307.3029.21.camel@Tobias-Karnat>
 <20101201123921.GA15530@a1.tnic>
 <1291209888.12511.11.camel@Tobias-Karnat>
 <20101201143329.GB18074@a1.tnic>
 <1291225614.8646.4.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1291225614.8646.4.camel@Tobias-Karnat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 06:46:54PM +0100, Tobias Karnat wrote:
> Am Mittwoch, den 01.12.2010, 15:33 +0100 schrieb Borislav Petkov:
> > Unfortunately, this is still incomplete because it is missing the Code: tag and
> > the end trace tag which looks like this
> > 
> > ---[ end trace ... ]---
> > 
> > and this is most probably so because we're halting and cannot print out
> > all the oops. Two things you can do:
> > 
> > 1. Connect the machine to another machine over serial- or netconsole.
> > Google for instructions how.
> > 
> > 2. If you can't do 1. you can try enabling CONFIG_BOOT_PRINTK_DELAY and
> > boot the kernel with 'boot_delay=10', for example, so that a 10ms delay
> > is inserted after each printk line. This might let us see more on the
> > console before halt and catch the whole oops.
> > 
> > Thanks.
> 
> Yes, boot_delay=10 has helped and I also removed the nvidia driver:
> 
> http://oi56.tinypic.com/eas0pg.jpg

Hmm, I see two backtraces now. I'm still not sure whether the first
one is actually the first one that happens since it is cut off at the
beginning.

If it is the first one, it should contain something like

[ ... ] Pid: ... , comm: ... Not tainted <kernel version> <DMI system name>

the important part being the "Not tainted" string. Can you check that
please?

Also, can you disable the EDAC subsystem in Kconfig and retry?
I'm trying to rule out some other issue since the backtraces are
inconclusive wrt EDAC.

Thanks.

-- 
Regards/Gruss,
    Boris.

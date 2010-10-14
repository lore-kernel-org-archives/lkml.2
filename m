Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0JNTqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:46:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab0JNTqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:46:00 -0400
Subject: Re: [PATCH] Serial: BUGFIX: uart_resume_port has an omitted
 condition.
From: Stanislav Brabec <sbrabec@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andr Goddard Rosa <andre.goddard@gmail.com>,
        Jason Wang <jason77.wang@gmail.com>, linux-serial@vger.kernel.org
In-Reply-To: <20101014184511.GA17096@kroah.com>
References: <1286949486-2446-1-git-send-email-myungjoo.ham@samsung.com>
	 <20101013062605.GB4393@suse.de>
	 <AANLkTimc-ETu4zrny=kmVRq8jnh2CDiVSqE-EXde4ioS@mail.gmail.com>
	 <1286969205.6082.700.camel@hammer.site>  <20101014184511.GA17096@kroah.com>
Content-Type: text/plain; charset="ISO-8859-2"
Organization: SUSE Linux, s. r. o.
Date: Thu, 14 Oct 2010 21:45:57 +0200
Message-ID: <1287085557.10610.18.camel@utx.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote: 
> > This disparity appeared deliberately in 4547be78. If you need
> > no_console_suspend and the hardware lets the device in an undefined
> > state after resume (i. e. PXA270), you need to call subset of the
> > resume, even if the suspend counterpart was not called. Yes, I can
> > imagine that it may be a source of problems.
 
> > It seems that support for no_console_suspend for all devices is becoming
> > more complicated. I guess that a new driver calls (maybe "save_state"
> > and "resume_state") or support for no_console_suspend directly in
> > drivers may be useful.
> 
> Ok, so I'm guessing that this patch is not to be applied then, correct?

I just compared it with Jason Wang's patches. MyungJoo Ham's patch is
exactly equal to the PATCH 1/2. So it already has my ACK and it is
pending as:

serial-core: skip call set_termios/console_start when no_console_suspend

Related thread can be found in linux-serial archives from August 2010:
[PATCH RESEND 0/2] two serial_core suspend/resume fixes

To MyungJoo Ham: Could you verify, that Jason Wang's patch 2/2 does not
break your system? My patch to fix PXA270 does not exist yet. I'll ask
you in future for testing.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/


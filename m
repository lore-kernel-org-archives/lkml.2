Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab2J3QY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:24:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20911 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933864Ab2J3QY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:24:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+PTP+3ylFNQqPEKXbJfHMn
Date: Tue, 30 Oct 2012 09:24:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] ARM: OMAP2+: move mailbox.h out of plat-omap
 headers
Message-ID: <20121030162441.GF11908@atomide.com>
References: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
 <1351530381-11459-2-git-send-email-omar.luna@linaro.org>
 <20121029175228.GD11908@atomide.com>
 <CALLhW=4ukBuRSVcPm2A37PgBhv33yKqk2G=Dz2XTUyswXw=JMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLhW=4ukBuRSVcPm2A37PgBhv33yKqk2G=Dz2XTUyswXw=JMg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Omar Ramirez Luna <omar.luna@linaro.org> [121030 05:20]:
> Tony,
> 
> On 29 October 2012 12:52, Tony Lindgren <tony@atomide.com> wrote:
> >> --- /dev/null
> >> +++ b/include/linux/platform_data/omap_mailbox.h
> >> @@ -0,0 +1,105 @@
> >
> > This file should only contain pure platform data needed
> > by the core omap code to pass to the mailbox driver.
> 
> Ok, looking at it closely, this header file is related to the API
> itself, there is nothing that could be actually considered as pure
> platform data, the structures are related with the mailbox framework
> and even if I split this file into two, the additional header would
> end up including the "platform_data" header unless I move
> save/restore_ctx functions and then export them as symbols for the
> API.
> 
> So, it might be better for the entire file to sit in
> linux/include/mailbox/ then.

OK to me.
 
> > The mailbox API header should be somewhere else,
> > like include/linux/mailbox/mailbox-omap.h or similar.
> 
> Ok.
> 
> > But shouldn't this all now be handled by using the
> > remoteproc framework?
> 
> Remoteproc doesn't handle the mailbox hardware directly, it still
> relies in the mailbox framework for the low level communications.
> E.g.: Proc1 has a message (virtqueue msg) queued to Proc2, uses
> mailbox msg to generate an interrupt to Proc2, Proc2 queries the
> message (virtqueue) based on the mailbox message received.

OK.

Greg, do these patches look OK to you to move to live under
drivers/mailbox?

Regards,

Tony

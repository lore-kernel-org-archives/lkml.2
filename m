Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2AQOsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:48:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab2AQOst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:48:49 -0500
Date: Tue, 17 Jan 2012 15:46:44 +0100
From: Andrew Jones <drjones@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, holt@sgi.com, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, takata@linux-m32r.org,
        geert@linux-m68k.org, yasutake.koichi@jp.panasonic.com,
        jonas@southpole.se, kyle@mcmartin.ca, deller@gmx.de,
        jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120117144644.GC3188@turtle.usersys.redhat.com>
References: <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com>
 <201201120918.53026.arnd@arndb.de>
 <20120112101805.GA2375@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
 <20120113122202.GB2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
 <4F1442C5.70500@redhat.com>
 <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 03:37:01PM -0800, David Rientjes wrote:
> > For instance, Why would CONFIG_EXPERT disable by default some HID devices?
> > I could understand why it is done for CONFIG_EMBEDDED, but certainly not
> > for an general EXPERT option.
> > 
> 
> Then this is a prime example that you've identified were it would make 
> sense to have the default value be dependant on EMBEDDED rather than 
> EXPERT.  Feel free to send a patch to the HID maintainers.
> 

How would you propose to write this patch? You say the default value
should be dependant on EMBEDDED, instead of EXPERT? So maybe something
like

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a421abd..73c2d39 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -63,7 +63,7 @@ menu "Special HID drivers"
 config HID_A4TECH
        tristate "A4 tech mice" if EXPERT
        depends on USB_HID
-       default !EXPERT
+       default !EMBEDDED
        ---help---
        Support for A4 tech X5 and WOP-35 / Trust 450L mice.

and the other HID drivers...

I guess it could be changed to 'if EXPERT || EMBEDDED', but at the moment
EMBEDDED selects EXPERT, so that's not currently necessary. I guess what's
above should be sufficient then. Oh, wait! That's exactly what this patch
does! And anybody who actually read it would have seen that.

I'm sorry if my writing style is starting to become a bit sarcastic. I
tend to get that way when I'm overly irritated. And I tend to get
irritated when people nack patches without reading them.

BTW, the HID maintainer, Jiri Kosina, is already on cc, since I cc'ed
every maintainer of the files that this patch touches.

Drew

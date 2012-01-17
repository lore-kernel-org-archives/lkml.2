Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2AQUyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:54:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63891 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab2AQUyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:54:07 -0500
Date: Tue, 17 Jan 2012 12:54:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Jones <drjones@redhat.com>
cc: Jerome Marchand <jmarchan@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
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
In-Reply-To: <20120117144644.GC3188@turtle.usersys.redhat.com>
Message-ID: <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de> <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com> <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com> <20120113122202.GB2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com> <4F1442C5.70500@redhat.com> <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com>
 <20120117144644.GC3188@turtle.usersys.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012, Andrew Jones wrote:

> > > For instance, Why would CONFIG_EXPERT disable by default some HID devices?
> > > I could understand why it is done for CONFIG_EMBEDDED, but certainly not
> > > for an general EXPERT option.
> > > 
> > 
> > Then this is a prime example that you've identified were it would make 
> > sense to have the default value be dependant on EMBEDDED rather than 
> > EXPERT.  Feel free to send a patch to the HID maintainers.
> > 
> 
> How would you propose to write this patch? You say the default value
> should be dependant on EMBEDDED, instead of EXPERT? So maybe something
> like
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index a421abd..73c2d39 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -63,7 +63,7 @@ menu "Special HID drivers"
>  config HID_A4TECH
>         tristate "A4 tech mice" if EXPERT
>         depends on USB_HID
> -       default !EXPERT
> +       default !EMBEDDED
>         ---help---
>         Support for A4 tech X5 and WOP-35 / Trust 450L mice.
> 
> and the other HID drivers...
> 

Um, no, HID_A4TECH is still only configurable for CONFIG_EXPERT with this 
patch.  Jerome's premise is that this should be configurable for 
CONFIG_EMBEDDED instead.  Please read what he wrote.

When it's configurable only for CONFIG_EMBEDDED, then you can propose that 
to the HID maintainers.  If they agree, then we don't care if users 
currently with CONFIG_EXPERT=y and CONFIG_EMBEDDED=n lose the option, but 
that needs to be handled on a case-by-case basis when breaking backwards 
compatibility.

> I guess it could be changed to 'if EXPERT || EMBEDDED', but at the moment
> EMBEDDED selects EXPERT, so that's not currently necessary. I guess what's
> above should be sufficient then. Oh, wait! That's exactly what this patch
> does! And anybody who actually read it would have seen that.
> 

One of many reasons why it's completely wrong, and is nacked.

> BTW, the HID maintainer, Jiri Kosina, is already on cc, since I cc'ed
> every maintainer of the files that this patch touches.
> 

That type of attitude is a great way for your patches to be lost in 
oblivion, you can't expect everyone on the cc list to be actively reading 
this thread.  I've considered not reading it myself since it's pretty 
pointless.  If you wish to submit kconfig patches for options that touch 
specific subsystems, you'll need to separate them out and propose them to 
the individual subsystem maintainers.

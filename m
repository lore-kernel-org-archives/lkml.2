Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1GFOTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:19:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab1GFOTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:19:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH V2 3/6] mpcore_wdt: Fix WDIOC_SETOPTIONS handling
Date: Wed, 6 Jul 2011 16:19:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Vitaly Kuzmichev <vkuzmichev@mvista.com>, linux-watchdog@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, Marc Zyngier <marc.zyngier@arm.com>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <20110706134806.GA8286@n2100.arm.linux.org.uk> <20110706135219.GB8286@n2100.arm.linux.org.uk>
In-Reply-To: <20110706135219.GB8286@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061619.27580.arnd@arndb.de>
X-Provags-ID: V02:K0:91YQSD79WwP33uk39BZx1Z/2ymjsRDM9CxT8hevSqzl
 /7h7FIqgTGWQFXYnAEKWvroxDSPldXm93G8zwOviVxJ/00XIAa
 q24YnnCEJREX4sdwl/hpr/jHxj0UL29U1Z7WpwYqgya3ebhe7x
 dlC6ElslrEWbBxOube3XglbbIoCpP0TmVX7BiyH0be9SJDGdT7
 uhG8Blk+PTXUIoGr/7Hmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011, Russell King - ARM Linux wrote:
> That looks like something which needs fixing in watchdog land.  And it's
> not too difficult:
> 
> 1. Change the existing WDIOC_SETOPTIONS to WDIOC_SETOPTIONS_OLD
> 2. Add a new, correctly defined WDIOC_SETOPTIONS.
> 3. Update all drivers to use WDIOC_SETOPTIONS.
> 4. Provide a helper which deals with WDIOC_SETOPTIONS_OLD and translates
>    it to the proper WDIOC_SETOPTIONS call (this could be just:
> 
>         if (cmd == WDIOC_SETOPTIONS_OLD) {
>                 static int first = 1;
>                 if (first)
>                         pr_warn("%s:%d used old WDIOC_SETOPTIONS call.  Please rebuild\n",
>                                 current->comm, current->pid);
>                 first = 0;
>                 cmd = WDIOC_SETOPTIONS;
>         }
> 
>    before any argument copies.
> 
> This means you preserve existing compatibility with userspace, yet gain
> a path to a non-broken ioctl interface.
> 
> As stuff gets rebuilt and replaced, you'll eventually be able to remove
> the above.  That period used to be two years for such simple changes.

Since Wim is currently doing a new core driver to be used by watchdog
drivers anyway, that sounds like a good idea to fix afterwards.
Note that the mpcore_wdt is the only driver that checks the direction
bit, so it's unlikely to cause problems for anything else.

> Hopefully, someone can let Wim know his email is broken...

This should get through to him I hope. Wim, see below.

> Also deleted
> the broken arm@kernel.org address.

Ok, sorry about that. I need to finally ask the kernel.org team to
set that up, I announced it too early.

	Arnd

> This is the mail system at host ylaen.iguana.be.
> 
> I'm sorry to have to inform you that your message could not
> be delivered to one or more recipients. It's attached below.
> 
> For further assistance, please send mail to <postmaster>
> 
> If you do so, please include this problem report. You can
> delete your own text from the attached returned message.
> 
>                    The mail system
> 
> <wim@infomag.iguana.be> (expanded from <wim@iguana.be>): Host or domain name
>     not found. Name service error for name=infomag.iguana.be type=AAAA: Host
>     found but no data record of requested type
> 


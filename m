Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab1BRSvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:51:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50158 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1BRSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:51:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Date: Fri, 18 Feb 2011 19:51:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <20110218143500.23b3044b@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1102181917520.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102181917520.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181951.32631.arnd@arndb.de>
X-Provags-ID: V02:K0:OfNM+Xj4fDWJ8l3rD54pjafAuiVQ744N1QAomPkezbk
 D32iQFZr8ZnZd75xW2DJ4DTdE+y4YLACsag9VDxUh6+DFgkLfo
 yya77XpYcpKeGvXudDnKcY8pzB9nDMZs/STpWbSvKfkO2puKbv
 /jD1wkHkWce31PeBWIyep36QLzHRGdHtWNWxw7oZuz7cdjp6bT
 Q0IuF7+RntIOv4hIHIN4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 February 2011 19:23:49 Thomas Gleixner wrote:
> On Fri, 18 Feb 2011, Alan Cox wrote:
> 
> > On Fri, 18 Feb 2011 19:17:38 +0530
> > "Subhasish Ghosh" <subhasish@mistralsolutions.com> wrote:
> > 
> > > Hello,
> > > 
> > > Regarding the semaphore to mutex migration.
> > > We are using down_trylock in interrupt context,
> > > mutex_trylock cannot be used in interrupt context, so we cannot use mutex in 
> > > our driver.
> > 
> > Then you probably need to rework your locking. Best bet might be to fix
> > all the other stuff and report the driver, and people can think about the
> > locking problem.
> 
> That semaphore is utterly useless to begin with. There are more
> serious locking problems than this one. Non serialized calls to
> suart_intr_clrmask/suart_intr_setmask are the most obvious ones.
> 
> Aside of that the code is complete unreadable.

I think it mostly suffers from the same problem as the CAN driver
I commented on earlier: One of the files (pruss_suart_api.c) was
clearly not written with Linux as the target, and the other files
try to work around this by wrapping a Linux driver around it.

The suart_api HAL stuff clearly needs to go away, so that the rest
can be rewritten into a proper device driver.

	Arnd

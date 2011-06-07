Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab1FGIlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:41:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:39234 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1FGIla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:41:30 -0400
Date: Tue, 7 Jun 2011 10:41:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Johannes Bauer <hannes_bauer@aon.at>
cc: Peter Zijlstra <peterz@infradead.org>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
In-Reply-To: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>
Message-ID: <alpine.LFD.2.02.1106071033350.11814@ionos>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Johannes Bauer wrote:

Please stop top-posting and use proper line breaks at 78

> > Peter Zijlstra wrote:
> > > "Monica Puig-Pey" wrote:

> > > I need to change the priority from inside the driver, when creating the 
> > > kernel thread.
> >
> > No you don't. How does you driver know about what priority is correct
> > wrt all the other running RT tasks on the system?
> > 
> > Determining the right priority in a fixed priority scheduling system is
> > a system wide problem, nobody but the administrator can possibly even
> > begin to solve it.
> > 
> > There's a reason all RT irq threads are started at 50, its plain
> > impossible to do better.

> Absolutly correct!
> 
> However, if you are running the system on an embedded platform,
> where the _WHOLE_ system (including priorities) is preconfigured and
> never touched, starting a irq thread with the right prio from start
> is a more straightforward method than having to invoke a script that
> changes it using userspace chrt tool.

Feel free to do that for your embedded system and carry the patch for
yourself if you think it's worth to avoid the extra init script.

But we do _not_ add stuff like this to the mainline simply because
there is no way to find a prio setting which is appropriate for all
users of a particular driver.

Aside of that the extra init script is definitely less annoying to
maintain than the crap you need to hack into random drivers.

Thanks,

	tglx

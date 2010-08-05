Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab0HEF4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:56:47 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60176 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190Ab0HEF4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:56:45 -0400
Date: Thu, 5 Aug 2010 07:56:29 +0200
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: paulmck@linux.vnet.ibm.com, david@lang.hm,
        Arve =?ISO-8859-15?Q?Hj=F8n?= =?ISO-8859-15?Q?nev=E5g?= 
	<arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805075629.07d5d88d@schatten.dmk.lab>
In-Reply-To: <20100805073359.4cb791c0@schatten.dmk.lab>
References: <20100801054816.GI2470@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm>
	<20100804185520.GA2417@srcf.ucam.org>
	<201008042251.08266.rjw@sisk.pl>
	<20100804205654.GA4986@srcf.ucam.org>
	<alpine.DEB.2.00.1008041529530.6545@asgard.lang.hm>
	<AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com>
	<alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm>
	<20100804231003.GL24163@linux.vnet.ibm.com>
	<20100805073359.4cb791c0@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010 07:33:59 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Wed, 4 Aug 2010 16:10:03 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> 
> No no. In the David-Lang-CGroup-Scheme[1](tm?) suspend-from-idle
> is used. For idle decision a certain subset of tasks is ignored. 
> 
> Where suspend is prevented by the trusted
> process in android-world taking a wakelock, here it would just prevent
> the system from going idle by arming timers.
> 
> This would be pretty equivalent to the suspend-blocker scheme and not
> introduce new userspace api. But the downside is, as Arve pointed out,
> that now one can not get full-idle-power-leverage while suspend
> is blocked. 
> 
> [1] http://permalink.gmane.org/gmane.linux.kernel/1018452  and
> following 
> 
> 
> Cheers,
> Flo
> 

There are a few downsides that got mentioned already in reponse..  I got
a little lagged behind. 

There are upsides to this approach like not
having a special purpose userspace api, conceptually integrating
suspend into the idle mechanism .. 

Short summary of the cons that got mentioned:

  -  applications need to resort to polling to keep the system
	out of idle (->  system will never be fully idle)

  -  the race between deciding to suspend and becoming active
	again is not handled

  -  no special statistics available

  -  the timers of the ignored applications will behave unexpected
	(as the monotonic clock is not stopped)... while applications
	have already to cope with network-loss, other side effects of
	suspend without monotonic clock stopped are to be expected...


Cheers,
Flo

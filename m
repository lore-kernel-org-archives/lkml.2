Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0FIPiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:38:04 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48312 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab0FIPiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:38:00 -0400
Date: Wed, 9 Jun 2010 17:37:40 +0200
From: Florian Mickler <florian@mickler.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: pm list <linux-pm@lists.linux-foundation.org>, james.bottomley@suse.de,
       markgross@thegnar.org, mgross@linux.intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Javier Cardona <javier@cozybit.com>, Jouni Malinen <j@w1.fi>,
       Rui Paulo <rpaulo@gmail.com>, Kalle Valo <kalle.valo@nokia.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/2] mac80211: make max_network_latency notifier
 atomic safe
Message-ID: <20100609173740.3851c6a5@schatten.dmk.lab>
In-Reply-To: <1276086425.14580.14.camel@jlt3.sipsolutions.net>
References: <1276074915-26879-1-git-send-email-florian@mickler.org>
	<1276076287.3727.15.camel@jlt3.sipsolutions.net>
	<20100609122050.1dd18132@schatten.dmk.lab>
	<1276080128.14580.5.camel@jlt3.sipsolutions.net>
	<20100609141643.14e9aedc@schatten.dmk.lab>
	<1276086425.14580.14.camel@jlt3.sipsolutions.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jun 2010 14:27:05 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2010-06-09 at 14:16 +0200, Florian Mickler wrote:
> 
> > That was also my first idea, but then I thought about qos and thought
> > atomic notification are necessary.
> > Do you see any value in having atomic notification? 
> > 
> > I have the following situation before my eyes:
> > 
> > 	Driver A gets an interrupt and needs (to service that
> > 	interrupt) the cpu to guarantee a latency of X because the
> > 	device is a bit icky.
> > 
> > Now, in that situation, if we don't immediately (without scheduling in
> > between) notify the system to be in that latency-mode the driver won't
> > function properly. Is this a realistic scene?
> > 
> > At the moment we only have process context notification and only 2
> > listeners.
> > 
> > I think providing for atomic as well as "relaxed" notification could be
> > useful. 
> > 
> > If atomic notification is deemed unnecessary, I have no
> > problems to just use schedule_work() in update request.
> > Anyway, it is probably best to split this. I.e. first make
> > update_request callable from atomic contexts with doing the
> > schedule_work in update_request and then
> > as an add on provide for constraints_objects with atomic notifications.
> 
> Well I remember http://thread.gmane.org/gmane.linux.kernel/979935 where
> Mark renamed things to "request" which seems to imply to me more of a
> "please do this" than "I NEED IT NOW!!!!!".
> 
> johannes

Yes. I just posted a version which uses schedule_work().
Just FYI, James has also posted his version which uses either a blocking
or an atomic notifier chain.
http://article.gmane.org/gmane.linux.kernel/996813

Cheers,
Flo


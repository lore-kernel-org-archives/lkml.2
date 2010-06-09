Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0FIM11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:27:27 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab0FIM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:27:25 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: make max_network_latency notifier
 atomic safe
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Mickler <florian@mickler.org>
Cc: pm list <linux-pm@lists.linux-foundation.org>, james.bottomley@suse.de,
       markgross@thegnar.org, mgross@linux.intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Javier Cardona <javier@cozybit.com>, Jouni Malinen <j@w1.fi>,
       Rui Paulo <rpaulo@gmail.com>, Kalle Valo <kalle.valo@nokia.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100609141643.14e9aedc@schatten.dmk.lab>
References: <1276074915-26879-1-git-send-email-florian@mickler.org>
	 <1276076287.3727.15.camel@jlt3.sipsolutions.net>
	 <20100609122050.1dd18132@schatten.dmk.lab>
	 <1276080128.14580.5.camel@jlt3.sipsolutions.net>
	 <20100609141643.14e9aedc@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 14:27:05 +0200
Message-ID: <1276086425.14580.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 14:16 +0200, Florian Mickler wrote:

> That was also my first idea, but then I thought about qos and thought
> atomic notification are necessary.
> Do you see any value in having atomic notification? 
> 
> I have the following situation before my eyes:
> 
> 	Driver A gets an interrupt and needs (to service that
> 	interrupt) the cpu to guarantee a latency of X because the
> 	device is a bit icky.
> 
> Now, in that situation, if we don't immediately (without scheduling in
> between) notify the system to be in that latency-mode the driver won't
> function properly. Is this a realistic scene?
> 
> At the moment we only have process context notification and only 2
> listeners.
> 
> I think providing for atomic as well as "relaxed" notification could be
> useful. 
> 
> If atomic notification is deemed unnecessary, I have no
> problems to just use schedule_work() in update request.
> Anyway, it is probably best to split this. I.e. first make
> update_request callable from atomic contexts with doing the
> schedule_work in update_request and then
> as an add on provide for constraints_objects with atomic notifications.

Well I remember http://thread.gmane.org/gmane.linux.kernel/979935 where
Mark renamed things to "request" which seems to imply to me more of a
"please do this" than "I NEED IT NOW!!!!!".

johannes


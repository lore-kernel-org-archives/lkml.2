Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab0FNOoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:44:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:37488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0FNOoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:44:13 -0400
Subject: Re: [linux-pm] [PATCH v4] pm_qos: make update_request non blocking
From: James Bottomley <James.Bottomley@suse.de>
To: Florian Mickler <florian@mickler.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Frederic Weisbecker <fweisbec@gmail.com>,
       markgross@thegnar.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100614163339.755a2b5b@schatten.dmk.lab>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
	 <1276097832.4343.223.camel@mulgrave.site>
	 <20100609180033.39d5b499@schatten.dmk.lab>
	 <1276099645.4343.257.camel@mulgrave.site>
	 <20100609183204.1eeca494@schatten.dmk.lab>
	 <1276103149.4343.350.camel@mulgrave.site>
	 <20100610094525.0449d797@schatten.dmk.lab>
	 <1276177144.27283.37.camel@mulgrave.site>
	 <20100610164118.15ec7a05@schatten.dmk.lab>
	 <1276266352.2862.70.camel@mulgrave.site>
	 <20100614163339.755a2b5b@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 09:44:06 -0500
Message-ID: <1276526646.5374.8.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 16:33 +0200, Florian Mickler wrote:
> On Fri, 11 Jun 2010 09:25:52 -0500
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > 
> > Actually, pm_qos_remove now needs a flush_scheduled work since you don't
> > want to return until the list is clear (since the next action may be to
> > free the object).
> 
> The work-items are allocated in the pm_qos objects (which get never
> freed), so we should be fine there.

That's not a safe assumption.  Once we get into drivers, timers and cpu
ilde states, I can see these things being in modules.

Regardless, it's bad programming practise to be using something after
the final remove is called, it certainly violates the principle of least
surprise and would usually eventually cause problems.

James



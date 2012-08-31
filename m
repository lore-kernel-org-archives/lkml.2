Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2HaV5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:57:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40027 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab2HaV5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:57:45 -0400
Date: Fri, 31 Aug 2012 23:02:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] drivers/tty: Folding Android's keyreset driver in
 sysRQ
Message-ID: <20120831230227.6e5008b5@pyramind.ukuu.org.uk>
In-Reply-To: <50413200.5010104@linaro.org>
References: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org>
	<20120830230129.GC21501@core.coreip.homeip.net>
	<50413200.5010104@linaro.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Why do we need to involve a platform device and not use, for example, a module
> > parameter, that could be set up from userspace?
> 
> The platform device comes from the original design and was included to
> minimise the amount of changes in code that make use of the current
> keyreset driver.

The platform device is IMHO the right answer. In this class of devices
the stuff is compiled in, the userspace is Android, there are no modules
and there is no reason for it to be configurable.

> I am definitely willing to explore the possibility of adding module
> parameter to complement the platform data but again, to avoid impacting
> board code I'm in favour of keeping the platform data/device - get back
> to me if you disagree.
> 
> Thinking back on this it may be better to call 'platform_driver_probe'
> rather than 'platform_driver_register'.  That way one wouldn't have to
> instantiate a platform_device.
> 
> > 
> > Also, why do we need reset_fn() and not simply invoke SysRq-B handler
> > that should call ctrl_alt_del() for us?
> 
> The reset_fn() gives an implementer the chance of calling some custom
> function before the reset sequence is started and in my opinion should

So why wouldn't that already be using the reset notifiers ?

Alan

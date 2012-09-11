Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab2IKHL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:11:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39460 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2IKHLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:11:54 -0400
Date: Tue, 11 Sep 2012 09:13:14 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v3] can: rename LED trigger name on netdev renames
Message-ID: <20120911071314.GA4766@gmail.com>
References: <20120907071934.GB37685@macbook.local>
 <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910142827.GB11000@vandijck-laurijssen.be>
 <504E30AE.50201@hartkopp.net>
 <20120910184049.GD2006@gmail.com>
 <504E3901.10901@hartkopp.net>
 <20120910200844.GC546@vandijck-laurijssen.be>
 <504ECF3B.1090709@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504ECF3B.1090709@hartkopp.net>
X-Operating-System: Linux balto-eee 3.6.0-rc3-balto-eee-00468-g15b91d3
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Tue, Sep 11, 2012 at 07:42:19AM +0200, Oliver Hartkopp wrote:
> On 10.09.2012 22:08, Kurt Van Dijck wrote:
> > But the initial name must have been set properly already in that case...
> 
> Yes it is.
> 
> See register_netdevice()
> 
> http://lxr.linux.no/#linux+v3.5.3/net/core/dev.c#L5453
> 
> 
> at the end NETDEV_REGISTER is notified:
> 
> http://lxr.linux.no/#linux+v3.5.3/net/core/dev.c#L5552
> 
> So it would be pretty elegant to create the LED trigger name in the notifier.
> This would allow to remove that code at the current init function too.

That would indeed be elegant, but in the current implementation
triggers only works for supported drivers, while putting registration in
the notifier would imply to use it also in unsupported ones, where you
would get a trigger which never triggers.

Is that what you had in mind?

Of course that would simplify another bit trigger integration to the
driver... if the target is to have support for all drivers that's a good
thing, through I think that triggers are mostly useful on embedded drivers.

Cheers,
Fabio

-- 
Fabio Baltieri

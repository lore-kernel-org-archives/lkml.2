Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab2IJUIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:08:51 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:65277 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab2IJUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:08:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAIlITlBtgrJV/2dsb2JhbABFhge1ToEIgiABAQUjBC8jEAsOCgICJgICFCUkiCcHqGuSfYEhiWsBhSMyYAOVXJAegmiBYQ
Date: Mon, 10 Sep 2012 22:08:44 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v3] can: rename LED trigger name on netdev renames
Message-ID: <20120910200844.GC546@vandijck-laurijssen.be>
Mail-Followup-To: Oliver Hartkopp <socketcan@hartkopp.net>,
	Fabio Baltieri <fabio.baltieri@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org
References: <20120907071934.GB37685@macbook.local>
 <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910142827.GB11000@vandijck-laurijssen.be>
 <504E30AE.50201@hartkopp.net>
 <20120910184049.GD2006@gmail.com>
 <504E3901.10901@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <504E3901.10901@hartkopp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 09:01:21PM +0200, Oliver Hartkopp wrote:
> On 10.09.2012 20:40, Fabio Baltieri wrote:
> 
> > On Mon, Sep 10, 2012 at 08:25:50PM +0200, Oliver Hartkopp wrote:
> >> On 10.09.2012 16:28, Kurt Van Dijck wrote:
> >>> Fabio,
> >>>
> >>> I followed all your contribution to this patch.
> > 
> > Thanks!
> > 
> >>
> >> You created that nice function but you are accessing priv->tx_led_trig below
> >> without checking the output of save_candev_priv() ...
> > 
> > Also, I noticed you removed the namespace check... wasn't it needed?
> > (just asking, I have no idea).

I don't actually know.
Anyone?

> > 
> >>> +	if (msg == NETDEV_CHANGENAME) {
> 
> 
> I do have a second remark.
> 
> What about always using the notifiers to name the LED triggers?
> 
> Looking into
> 
> http://lxr.linux.no/#linux+v3.5.3/include/linux/netdevice.h#L1526
> 
> we have NETDEV_CHANGENAME but what about
> 
> 	NETDEV_REGISTER
> 
> ???
> 
> When changing and updating the LED trigger name always inside the notifier, we
> should never run into any locking or race conditions ...
> 
> What do you think about this idea?
> 
But the initial name must have been set properly already in that case...

Kurt

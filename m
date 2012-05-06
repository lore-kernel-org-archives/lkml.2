Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab2EFNSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 09:18:45 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18911 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab2EFNSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 09:18:44 -0400
Date: Sun, 6 May 2012 15:18:42 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Anton Vorontsov <cbouatmailru@gmail.com>
cc: Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: Re: [PATCH] ISP1704 USB Charger: Fix use-after-free error in
 isp1704_charger_probe()
In-Reply-To: <20120506031212.GF29576@lizard>
Message-ID: <alpine.LNX.2.00.1205061517321.29039@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204222210290.27455@swampdragon.chaosbits.net> <201204222234.59624.marex@denx.de> <20120506031212.GF29576@lizard>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry about the late reply, I've been away from my mailbox for a while.

On Sat, 5 May 2012, Anton Vorontsov wrote:

> On Sun, Apr 22, 2012 at 10:34:59PM +0200, Marek Vasut wrote:
> [...]
> > > -
> > >  	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
> > > -
> > >  	isp1704_charger_set_power(isp, 0);
> > > +	kfree(isp);
> 
> Dan Carpenter sent a similar fix ~month ago, so it's in already.
> 
Ok :)

> > Use devm_kzalloc() and be done with all this goo?
> 
> Yeah, that's actually a good idea.
> 
No promises, but I may look into this in a few days.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


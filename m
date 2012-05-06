Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2EFDNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 23:13:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49909 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2EFDNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 23:13:39 -0400
Date: Sat, 5 May 2012 20:12:12 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Marek Vasut <marex@denx.de>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: Re: [PATCH] ISP1704 USB Charger: Fix use-after-free error in
 isp1704_charger_probe()
Message-ID: <20120506031212.GF29576@lizard>
References: <alpine.LNX.2.00.1204222210290.27455@swampdragon.chaosbits.net>
 <201204222234.59624.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201204222234.59624.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 10:34:59PM +0200, Marek Vasut wrote:
[...]
> > -
> >  	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
> > -
> >  	isp1704_charger_set_power(isp, 0);
> > +	kfree(isp);

Dan Carpenter sent a similar fix ~month ago, so it's in already.

> Use devm_kzalloc() and be done with all this goo?

Yeah, that's actually a good idea.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

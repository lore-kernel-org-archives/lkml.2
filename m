Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1GRHPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 03:15:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab1GRHPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 03:15:45 -0400
Date: Mon, 18 Jul 2011 10:16:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9] vhost: experimental tx zero-copy support
Message-ID: <20110718071606.GA29538@redhat.com>
References: <20110717193540.GA29392@redhat.com>
 <alpine.LNX.2.00.1107172153030.32359@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107172153030.32359@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 10:01:41PM +0200, Jesper Juhl wrote:
> > @@ -28,10 +29,18 @@
> >  
> >  #include "vhost.h"
> >  
> > +static int zcopytx;
> > +module_param(zcopytx, int, 0444);
> 
> Should everyone be able to read this? How about "0440" just to be 
> paranoid? or?

I find it very helpful to have the parameter visible in sysfs.
Given that:

[mst@tuck linux-2.6]$ grep module_param drivers/net/*c|grep [64]44|wc -l
14
[mst@tuck linux-2.6]$ grep module_param drivers/net/*c|grep [64]40|wc -l
0
[mst@tuck linux-2.6]$ grep module_param drivers/net/*c|grep [64]00|wc -l
7

So at least the precedent is against 0440.  What do you think?


-- 
MST

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0HaQQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:16:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42634 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0HaQQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dJtYvA0mfA9YhtStyr6yVKlb0FHie5Ks7HjRHplvZsUKdSTqOyrCLIBorzGuS+YREZ
         KDgThZ6AewME+dX2xUPIK67RCIULlDAD/EBfQFzTqKauadPVkRZF2P3v3SZeKzb4TgXU
         QbGHlHMPgnf3/lT3Hy+4YmQHNw9138rgZQgnw=
Date: Tue, 31 Aug 2010 20:16:44 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: walter harms <wharms@bfs.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/7] drivers/macintosh/via-pmu-led.c: Add of_node_put
 to avoid memory leak
Message-ID: <20100831161644.GA14505@albatros>
References: <1283075566-27441-1-git-send-email-julia@diku.dk>
 <1283075566-27441-2-git-send-email-julia@diku.dk>
 <4C7D247F.4060500@bfs.de>
 <Pine.LNX.4.64.1008311807470.2668@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008311807470.2668@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 18:08 +0200, Julia Lawall wrote:
> On Tue, 31 Aug 2010, walter harms wrote:
> 
> > 
> > 
> > Julia Lawall schrieb:
> > > Add a call to of_node_put in the error handling code following a call to
> > > of_find_node_by_path.
[...]
> > > --- a/drivers/macintosh/via-pmu-led.c
> > > +++ b/drivers/macintosh/via-pmu-led.c
> > > @@ -92,8 +92,10 @@ static int __init via_pmu_led_init(void)
> > >  	if (dt == NULL)
> > >  		return -ENODEV;
> > >  	model = of_get_property(dt, "model", NULL);
> > > -	if (model == NULL)
> > > +	if (model == NULL) {
> > > +		of_node_put(dt);
> > >  		return -ENODEV;
> > > +	}
> > >  	if (strncmp(model, "PowerBook", strlen("PowerBook")) != 0 &&
> > >  	    strncmp(model, "iBook", strlen("iBook")) != 0 &&
> > >  	    strcmp(model, "PowerMac7,2") != 0 &&
> > > 
> > 
> > is there any rule that says when to use strncmp ? it seems perfecly valid to use strcpy here
> > (what is done in the last cmp).
> 
> Perhaps there are some characters after eg PowerBook that one doesn't want 
> to compare with?

It seems to me that model has no '\0' in the end. If model is got from
the hardware then we should double check it - maybe harware is buggy.
Otherwise we'll overflow model.

But why strcmp(model, "PowerMac7,2")? IMO it should be replaced
with strncmp().

-- 
Vasiliy

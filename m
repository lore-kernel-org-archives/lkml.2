Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0HaQNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:13:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53789 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0HaQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:13:30 -0400
Date: Tue, 31 Aug 2010 10:13:26 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Julia Lawall <julia@diku.dk>
Cc: walter harms <wharms@bfs.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/7] drivers/macintosh/via-pmu-led.c: Add of_node_put
 to avoid memory leak
Message-ID: <20100831161326.GA6347@angua.secretlab.ca>
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

On Tue, Aug 31, 2010 at 06:08:19PM +0200, Julia Lawall wrote:
> On Tue, 31 Aug 2010, walter harms wrote:
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

Yes.  The model property on powermacs always has the version number.   strncmp makes sure that *all* PowerBooks and iBooks are matched.

g.

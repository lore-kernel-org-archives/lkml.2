Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0HXTq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:46:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37271 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab0HXTqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:46:25 -0400
Date: Tue, 24 Aug 2010 21:46:23 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/char/agp: Eliminate memory leak
In-Reply-To: <20100824171644.GL29330@bicker>
Message-ID: <Pine.LNX.4.64.1008242146040.14009@ask.diku.dk>
References: <Pine.LNX.4.64.1008241639130.15172@ask.diku.dk>
 <20100824171644.GL29330@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Dan Carpenter wrote:

> On Tue, Aug 24, 2010 at 04:39:29PM +0200, Julia Lawall wrote:
> >  
> > -	error = agp_add_bridge(bridge);
> > +	return agp_add_bridge(bridge);
> >  
> 
> 	error = agp_add_bridge(bridge);
> 	if (error)
> 		goto fail;
> 	return 0;

Good point.  I will send another patch.

julia

> >  fail:
> > +	kfree(fake_bridge_dev);
> >  	return error;
> >  }
> >  
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

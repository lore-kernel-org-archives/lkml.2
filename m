Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1FFRIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:08:45 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48056 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab1FFRIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:08:43 -0400
Date: Mon, 6 Jun 2011 13:07:46 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
Subject: Re: bridge/netfilter: regression in 2.6.39.1
Message-ID: <20110606170746.GD1000@hmsreliant.think-freely.org>
References: <4DE93422.3070000@ahsoftware.de>
 <20110606111507.GA1000@hmsreliant.think-freely.org>
 <4DECBEA3.6070408@ahsoftware.de>
 <1307362358.3098.6.camel@edumazet-laptop>
 <4DECCCC0.70905@ahsoftware.de>
 <1307366166.3098.15.camel@edumazet-laptop>
 <4DECD657.9010807@ahsoftware.de>
 <1307370363.3098.37.camel@edumazet-laptop>
 <20110606153213.GC1000@hmsreliant.think-freely.org>
 <1307376705.3098.58.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307376705.3098.58.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.5 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 06:11:45PM +0200, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 11:32 -0400, Neil Horman a écrit :
> 
> > Not to drag this out further, but since you illustrated the correct way to do
> > this with the blackhole_ops test, and this modification now gives us two
> > instances of that case, would it perhaps be better to just do this in
> > dst_metrics_write_ptr:
> > 
> > return dst->ops->cow_metrics ? return dst->ops->cow_metrics(dst, p) : NULL;
> > 
> > Then we could eliminate the two functions that do nothing be retun NULL (along
> > with their respective call instructions), and save any future users from having
> > to remember to include a dummy cow_metrics method if they happen to set the read
> > only flag on thier dst_ops?
> 
> Well, I prefer how David coded the thing.
> We can add selective traces where we want.
> 
> Having a default behavior might give much more work to find a bug in
> this area. A NULL pointer access gives us an immediate indication.
> 
> Its a bit late to add an "if (dst->ops->cow_metrics)" test now that we
> covered all call sites ;)
> 
> But we probably have more bugs elsewhere, because of many dst changes in
> 2.6.39
Ok, sounds reasonable to me.

Reviewed-by: Neil Horman <nhorman@tuxdriver.com>

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

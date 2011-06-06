Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1FFQLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:11:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47255 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab1FFQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ENSrXIVSdOtG8WPL+CQUxZ0+85S5pkRkuGFUqsyD0OTQ/mCJ2+Z9PVWN46MMo5p0l4
         DvTnJFq75n5bHiUI15TgwFFsPn6T8FSwihsFLuEUOqoOaKpgvE7eYHNDv8gFP6XddZmh
         qNIB6bygst/4rnrMYMEbMImsH/Dm0AzQ09Xd8=
Subject: Re: bridge/netfilter: regression in 2.6.39.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
In-Reply-To: <20110606153213.GC1000@hmsreliant.think-freely.org>
References: <4DE93422.3070000@ahsoftware.de>
	 <20110606111507.GA1000@hmsreliant.think-freely.org>
	 <4DECBEA3.6070408@ahsoftware.de> <1307362358.3098.6.camel@edumazet-laptop>
	 <4DECCCC0.70905@ahsoftware.de> <1307366166.3098.15.camel@edumazet-laptop>
	 <4DECD657.9010807@ahsoftware.de> <1307370363.3098.37.camel@edumazet-laptop>
	 <20110606153213.GC1000@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 18:11:45 +0200
Message-ID: <1307376705.3098.58.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 11:32 -0400, Neil Horman a écrit :

> Not to drag this out further, but since you illustrated the correct way to do
> this with the blackhole_ops test, and this modification now gives us two
> instances of that case, would it perhaps be better to just do this in
> dst_metrics_write_ptr:
> 
> return dst->ops->cow_metrics ? return dst->ops->cow_metrics(dst, p) : NULL;
> 
> Then we could eliminate the two functions that do nothing be retun NULL (along
> with their respective call instructions), and save any future users from having
> to remember to include a dummy cow_metrics method if they happen to set the read
> only flag on thier dst_ops?

Well, I prefer how David coded the thing.
We can add selective traces where we want.

Having a default behavior might give much more work to find a bug in
this area. A NULL pointer access gives us an immediate indication.

Its a bit late to add an "if (dst->ops->cow_metrics)" test now that we
covered all call sites ;)

But we probably have more bugs elsewhere, because of many dst changes in
2.6.39




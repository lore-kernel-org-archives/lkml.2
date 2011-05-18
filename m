Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab1ERTkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:40:46 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52028 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab1ERTkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MfDF4PyhSBwTOv3etde2PoZV6QdQjGhnPYJak5fqhLfS1nT8mh33pot53FAMBlw06s
         D1PPSOsGAh5b9jR9/bbpYGoKVdgIxYCy9Uy0J74Gw6N35FnLAzbvK5a6Ic1M7nOXkYpt
         JFU0rb3gaf3mVsPR0CvrQj6Q3lkko3hd3X+tU=
MIME-Version: 1.0
In-Reply-To: <20110518.152653.1486764697527722925.davem@davemloft.net>
References: <1305619677.2850.11.camel@edumazet-laptop> <1305715384-81716-1-git-send-email-tsunanet@gmail.com>
 <20110518.152653.1486764697527722925.davem@davemloft.net>
From: tsuna <tsunanet@gmail.com>
Date: Wed, 18 May 2011 12:40:21 -0700
Message-ID: <BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
To: David Miller <davem@davemloft.net>
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:26 PM, David Miller <davem@davemloft.net> wrote:
> If you read the ietf draft that reduces the initial RTO down to 1
> second, it states that if we take a timeout during the initial
> connection handshake then we have to revert the RTO back up to 3
> seconds.
>
> This fallback logic conflicts with being able to only change the
> initial RTO via sysctl, I think.  Because there are actually two
> values at stake and they depend upon eachother, the initial RTO and
> the value we fallback to on initial handshake retransmissions.
>
> So I'd rather get a patch that implements the 1 second initial
> RTO with the 3 second fallback on SYN retransmit, than this patch.
>
> We already have too many knobs.

I was hoping this knob would be accepted because this is such an
important issue that it even warrants an IETF draft to attempt to
change the standard.  I'm not sure how long it will take for this
draft to be accepted and then implemented, so I thought adding this
simple knob today would really help in the future.

Plus, should the draft be accepted, this knob will still be just as
useful (e.g. to revert back to today's behavior), and people might
want to consider adding another knob for the fallback initRTO (this is
debatable).  I don't believe this knob conflicts with the proposed
change to the standard, it actually goes along with it pretty well and
helps us prepare better for this upcoming change.

I agree that there are too many knobs, and I hate feature creep too,
but I've found many of these knobs to be really useful, and the degree
to which Linux's TCP stack can be tuned is part of what makes it so
versatile.

-- 
Benoit "tsuna" Sigoure
Software Engineer @ www.StumbleUpon.com

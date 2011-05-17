Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1EQMUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:20:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64457 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1EQMU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L8vD4Yd8zXk2n6Q+yG9qsFoF1eH+NDmZlXf+pRLQRN/P3vm9qwFJR0g2UPVKUUXBax
         tExn4zo6nhyGi72S66Y1WNiL0GHc6+NrvOTS8uyW6kpaHfVhaLJr8UGft+6EW6nh+a+t
         2R+47f2aUQ0lNa6u0Rf/DICQSPoZYGnW32tt4=
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Benoit Sigoure <tsunanet@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <e6b52d895fca947b4cce2896d593619b@localhost>
References: <1305618020-72535-1-git-send-email-tsunanet@gmail.com>
	 <1305618020-72535-2-git-send-email-tsunanet@gmail.com>
	 <1305619677.2850.11.camel@edumazet-laptop>
	 <e6b52d895fca947b4cce2896d593619b@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 14:20:23 +0200
Message-ID: <1305634823.2850.90.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 13:02 +0200, Hagen Paul Pfeifer a écrit :
> On Tue, 17 May 2011 10:07:57 +0200, Eric Dumazet wrote:
> 
> > I wont discuss if introducing a new sysctl is welcomed, only on patch
> > issues. I believe some work in IETF is done to reduce the 3sec value to
> > 1sec anyway.
> 
> Why not? 

Just because I let this point to David and others. I personally dont
care that much.

> I though all new knobs in this area should be done on a per route
> metric so it can be controlled on a per path basis. RTO should be
> adjustable on a per path basis, because it depends on the path.
> 

Adding many knobs to each clone had a huge cost on previous kernels.
(Think some machines have millions entries in IP route cache), this used
quite a lot of memory.

With latest David work, we'll consume less ram, because we can now share
settings, instead of copying them on each dst entry.



> Some months back [1] I posted a patch to enable/disable TCP quick ack
> mode, which has nothing to do with network paths, just with a local server
> policy. But David rejected the patch with the argument that I should use a
> per path knob (this is a little bit inapprehensible for me, but David has
> the last word).

Well, if nobody speaks after David, he has the last word indeed.

BTW, I remember Stephen actually asked the per route thing, not David.

http://kerneltrap.org/mailarchive/linux-netdev/2010/8/23/6283641

Then David also stated it :

http://kerneltrap.org/mailarchive/linux-netdev/2010/8/23/6283678

If you really want tcp_quickack thing you really should do it as
requested by both Stephen & David ;)

Unfortunately, I dont know if its really needed or worthwhile.



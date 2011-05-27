Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab1E0T5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:57:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40694 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab1E0T5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kc64yTluNTkoChWWJti32tmAUUVJ+bbzZA9mO8sBlMpF3mPrCYniVZhHZhawY/u4vN
         oUo1XYU4pjiDOyNup+7YDW4IVjoDm/QQfz3RCCt76WZgwGLn/oqYf7P7u/9vnoajML3T
         Oeb7J+T6G9Osmi6d+cx70K+Lxx7Pk0Q78KGdk=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: David Miller <davem@davemloft.net>,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        Yann Dupont <Yann.Dupont@univ-nantes.fr>,
        Denys Fedoryshchenko <denys@visp.net.lb>
In-Reply-To: <4DDFE4D6.4010000@fb.com>
References: <201104250033.03401.maxi@daemonizer.de>
	 <1303878240.2699.41.camel@edumazet-laptop>
	 <1303878771.2699.44.camel@edumazet-laptop>
	 <201104271352.00601.maxi@daemonizer.de>
	 <20110512211033.GA3468@dev1756.snc6.facebook.com>
	 <1305234953.2831.2.camel@edumazet-laptop>
	 <20110524213327.GA3917@dev1756.snc6.facebook.com>
	 <1306291469.3305.11.camel@edumazet-laptop>
	 <20110525060609.GA32244@dev1756.snc6.facebook.com>
	 <1306305331.3305.22.camel@edumazet-laptop>  <4DDEAA3C.7020502@fb.com>
	 <1306439246.2543.10.camel@edumazet-laptop>  <4DDECA9B.8080206@fb.com>
	 <1306447292.2543.32.camel@edumazet-laptop>  <4DDEEBC5.80804@fb.com>
	 <1306466831.2543.58.camel@edumazet-laptop>  <4DDFE4D6.4010000@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 21:56:59 +0200
Message-ID: <1306526219.2533.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 27 mai 2011 à 10:52 -0700, Arun Sharma a écrit :
> On 5/26/11 8:27 PM, Eric Dumazet wrote:
> 
> Looks good. Thanks for taking care of this.
> 
> > +static bool atomic_add_unless_return(atomic_t *ptr, int a, int u, int *newv)
> > +{
> > +	int cur, old = atomic_read(ptr);
> > +
> > +	while (old != u) {
> > +		*newv = old + a;
> > +		cur = atomic_cmpxchg(ptr, old, *newv);
> > +		if (cur == old)
> > +			return true;
> > +		old = cur;
> > +	}
> > +	return false;
> > +}
> 
> This looks very similar to atomic_add_unless(). If we had a
> 
> __atomic_add_unless() that returned "old", we could then do:
> 
> atomic_add_unless() { return __atomic_add_unless() != u }
> atomic_add_unless_return() { return __atomic_add_unless() + a}
> 

Sure !

I preferred to not touch lot of files in kernel (atomic_add_unless() is
defined in several files) because its a stable candidate patch (2.6.36+)

So a cleanup patch for 2.6.40+ is certainly doable, do you want to do
this ?

Thanks




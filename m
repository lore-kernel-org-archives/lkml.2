Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0LWMMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:12:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56806 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab0LWMMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:12:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FryqK+jXNTouBqVdIiFKmtg5ahwEtA1At6thcUfyExfvraE1uiivRzCbBifqwTHB7M
         DR3clmf17hZiKenhATcOBby2NDnXunCuEIKvE07TMi8ZL4bCdI/oGe2qRmw0tLFan14W
         gG2Z4BEvG6BO59QyP71znYcG472GJXmqvXN0U=
Subject: Re: Help: major pppoe regression since 2.6.35 (panic on first ppp
 conection)?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joel Soete <soete.joel@scarlet.be>
Cc: Jarek Poplawski <jarkao2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <4D132C5F.8090404@scarlet.be>
References: <20101222110021.GA8985@ff.dom.local>
	 <4D122093.6060900@scarlet.be> <1293035100.3027.247.camel@edumazet-laptop>
	 <4D132C5F.8090404@scarlet.be>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 13:12:28 +0100
Message-ID: <1293106348.7789.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 23 décembre 2010 à 11:02 +0000, Joel Soete a écrit :
> Hello Eric,
> 
> 
> On 12/22/2010 04:25 PM, Eric Dumazet wrote:
> [snip]
> >
> > Something overwrites nr_frags in skb_shinfo(skb)
> >
> > As skb_shinfo follows head portion of an skb, something overflows skb
> > head
> >
> > Please try adding some room like in following patch ?
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index e6ba898..adf2834 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -187,6 +187,7 @@ enum {
> >    * the end of the header data, ie. at skb->end.
> >    */
> >   struct skb_shared_info {
> > +	char		filler[64];
> >   	unsigned short	nr_frags;
> >   	unsigned short	gso_size;
> >   	/* Warning: this field is not always filled in (UFO)! */
> >
> Sorry for delay but I have good news, I am sending this answer from:
> $ uname -a
> Linux sidh2 2.6.37-rc7-amd64-t1 #1 SMP Thu Dec 23 10:30:27 GMT 2010 x86_64 GNU/Linux
> 
> with your tips ;<) (without kernel had already died)
> 
> That said how can find stuff overflowing skb head? (all I say, is that this issue started with 2.6.34-git6???)
> 
> Thanks a lot,

You're welcome. At least we know were to search. Thanks !

I am taking holidays right now for about 5 days, I guess someone else
might find the bug before me ;)




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab0GENaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:30:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40583 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab0GENaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qjFvyo+C5WmGPDPMiDYZtfYs1y6bx/XWYRXFYjDp4HiNKNTLgHX3t/CFey3AlrKM/U
         cVH1yofeEuCu8/7hqPxXoaZMlXP0tvf/fAkn82zXRJL45DkT+y7AnygwRWbfhkX8Blv4
         BEbnUyeb62SCJjKIerRMhsrEb7+rimc/Tso6E=
Subject: Re: Fwd: Possible bug in net/ipv4/route.c?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20100705120617.GA6267@gondor.apana.org.au>
References: <20100705120617.GA6267@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 14:59:14 +0200
Message-ID: <1278334754.2877.173.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 05 juillet 2010 à 20:06 +0800, Herbert Xu a écrit :
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >> 2) The layer using skb->cb[] should clear this area after use and
> >> before handing the skb to another layer.  Ubicom should modify the
> >> driver to clear the skb->cb[] area before sending it up the line.
> >> 
> > 
> > This is the right option. If you use one word in cb[], only your driver
> > knows how to clear it efficiently.
> 
> Absolutely not! No protocol stack should rely on an external skb
> having a zero cb.
> 

Why do we clear full 48 bytes skb->cb[] in skb_alloc(), if no protocol
stack should rely it being zero ?




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0LJQzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:55:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43040 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0LJQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qHEkFDH0XVlrhYQBTcGkEGrRI4PFcVLi9WR6n/T86NJzAzW9bmEeh1nppcidTsq96V
         l4GWFFEMNqQzMVC4kH8YvK/u98yIgNB3gh05ltIDi1K3oCkiAUfOPSF876ynWCBH7kFa
         ssRih2P+k4Wbq3smeBYtGR2DuETNeqR7xxBEA=
Subject: Re: [RFC PATCH V2 5/5] Add TX zero copy in macvtap
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>, mst@redhat.com,
        xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291998355.2167.53.camel@localhost.localdomain>
References: <1291976026.2167.49.camel@localhost.localdomain>
	 <1291976864.3580.7.camel@edumazet-laptop>
	 <1291998355.2167.53.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 17:55:06 +0100
Message-ID: <1292000106.3580.210.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 10 décembre 2010 à 08:25 -0800, Shirley Ma a écrit :
> On Fri, 2010-12-10 at 11:27 +0100, Eric Dumazet wrote:
> > You could make one atomic_add() outside of the loop, and factorize
> > many
> > things...
> > 
> > atomic_add(len, &skb->sk->sk_wmem_alloc);
> > skb->data_len += len;
> > skb->len += len;
> > skb->truesize += len;
> > while (len) {
> >         ...
> > } 
> 
> Yep, thanks, will update it!

Also take a look at skb_fill_page_desc() helper, and maybe
skb_add_rx_frag() too.

The atomic op should be factorized for sure, but other adds might be
done by helpers to keep code short.




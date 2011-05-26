Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab1EZVJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:09:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34671 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862Ab1EZVJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:09:05 -0400
Subject: Re: [PATCH V6 2/4 net-next] skbuff: Add userspace zero-copy
 buffers in skb
From: Shirley Ma <mashirle@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306443325.2543.22.camel@edumazet-laptop>
References: <1306438593.5180.33.camel@localhost.localdomain>
	 <1306440247.2543.14.camel@edumazet-laptop>
	 <1306441442.5180.51.camel@localhost.localdomain>
	 <1306443325.2543.22.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 14:08:37 -0700
Message-ID: <1306444117.5180.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 22:55 +0200, Eric Dumazet wrote:
> Le jeudi 26 mai 2011 à 13:24 -0700, Shirley Ma a écrit :
> 
> > I could reduce callback pointer by moving it to *arg, but not desc,
> this
> > indicates that which buffer DMA hasn't done yet in *arg.
> 
> 
> I guess you dont need to use skb itself to hold all your states ?
> 
> I understand its convenient for you, but I believe its worth the pain
> to
> use only one pointer to a (small) object where you put all your stuff.
> 
> Some machines alloc/free millions of skbs per second. 
> 
> If/when most skb uses are for userspace zero-copy buffers we can
> embbed
> your small object in skb itself ;)

You are right, w/o this desc, there will be lots of alloc/dealloc in the
caller side. To have better performance, maybe I should have changed
most skbs to use zero-copy buffers. :)

Ok, for now let me try to move it to caller, just leave one pointer
*uarg here.

Thanks
Shirley


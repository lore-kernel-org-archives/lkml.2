Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab1EZUzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:55:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45223 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab1EZUzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iuQiDsEkGm/95b0j/osFLa8Gkp+TxB+1EhNQ+RlUAV9Q+WCZvZgnP1HlbekzS64rZH
         jDC+O3k4txmp8wUNA0pnvLXFr8EDaYtiA+XA+n5stpF2Gr0BL4m/uMcahjoARNiTGLwJ
         1MIqAsAg8gh/9Cku/Erl9LHfVGHxCYvw7MaqQ=
Subject: Re: [PATCH V6 2/4 net-next] skbuff: Add userspace zero-copy
 buffers in skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306441442.5180.51.camel@localhost.localdomain>
References: <1306438593.5180.33.camel@localhost.localdomain>
	 <1306440247.2543.14.camel@edumazet-laptop>
	 <1306441442.5180.51.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 22:55:25 +0200
Message-ID: <1306443325.2543.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 mai 2011 à 13:24 -0700, Shirley Ma a écrit :

> I could reduce callback pointer by moving it to *arg, but not desc, this
> indicates that which buffer DMA hasn't done yet in *arg.


I guess you dont need to use skb itself to hold all your states ?

I understand its convenient for you, but I believe its worth the pain to
use only one pointer to a (small) object where you put all your stuff.

Some machines alloc/free millions of skbs per second. 

If/when most skb uses are for userspace zero-copy buffers we can embbed
your small object in skb itself ;)



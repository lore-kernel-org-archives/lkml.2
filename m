Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0HXUKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:10:04 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51067 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab0HXUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UXSZ/wxtteVTfBH0L5eHba1VEOPpLcdbfu57tLOAYYvEWt3mTzoHLLgBXc1Z+wWM53
         7/u0URuX8vBqQQI5zx8RWIkJzBWeqYEs+IgbxRO3TtHLm3kUZeAkCB6yCZOx8vuEd1nc
         Dh0aWj+p/aAwq9/Rr4IANSY+QJLtKsZZAReiE=
Subject: Re: RFC: MTU for serving NFS on Infiniband
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Marc Aurele La France <tsi@ualberta.ca>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
	 <20100823080543.319143e3@nehalam>
	 <alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca>
	 <1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
	 <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 22:09:32 +0200
Message-ID: <1282680572.2467.78.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 août 2010 à 13:49 -0600, Marc Aurele La France a écrit :

> 
> Any payload has to either fit in the MTU, or has to be broken up into 
> MTU-sized (or less) fragments, come hell or high water.  That this is done 
> centrally is a good thing.  It is the "(or less)" part that I am working 
> towards here.
> 

Could you post a full stack trace, to help me understand the path from
NFS to ip_append_data ?

I suspect this is UDP transport ?

This reminds me a patch I wrote for IPV6 : We were allocating a huge
(MTU sized) buffer, just to fill few bytes in it...


commit 72e09ad107e78d69ff4d3b97a69f0aad2b77280f
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Sat Jun 5 03:03:30 2010 -0700

    ipv6: avoid high order allocations
    
    With mtu=9000, mld_newpack() use order-2 GFP_ATOMIC allocations, that
    are very unreliable, on machines where PAGE_SIZE=4K
    
    Limit allocated skbs to be at most one page. (order-0 allocations)
    
    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>



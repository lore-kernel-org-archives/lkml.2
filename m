Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1LUIsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:48:51 -0500
Received: from outm2.farsite.co.uk ([82.108.209.243]:11513 "EHLO
	outm2.farsite.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1LUIsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:48:50 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Dec 2011 03:48:49 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 2/8] farsync: Fix confusion about DMA address and buffer offset types
Date: Wed, 21 Dec 2011 08:33:33 -0000
Message-ID: <F0A3125A154C5B46B8540D5E65D671050153356A@captain.hq.farsitecommunications.com>
In-Reply-To: <1324446073.2844.190.camel@deadeye>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/8] farsync: Fix confusion about DMA address and buffer offset types
Thread-Index: Acy/oy+t9+HPpfdKS/qE5iavWUfL1gAF+O5w
References: <1324430940.2844.144.camel@deadeye> <1324431172.2844.147.camel@deadeye> <20111220.234656.658595607282312696.davem@davemloft.net> <1324446073.2844.190.camel@deadeye>
From: "Kevin Curtis" <kevin.curtis@farsite.com>
To: "Ben Hutchings" <ben@decadent.org.uk>,
        "David Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBL8mvaH010922

Hi,
    Thanks for the patches.  I will apply them to the master copy of the source code here.


Regards


Kevin Curtis
Linux Development
FarSite Communications Ltd http://www.farsite.com
Winner of The Queen's Award for Enterprise 2009
tel:Â  +44 1256 330461
fax:Â  +44 1256 854931



-----Original Message-----
From: Ben Hutchings [mailto:ben@decadent.org.uk] 
Sent: 21 December 2011 05:41
To: David Miller
Cc: Kevin Curtis; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] farsync: Fix confusion about DMA address and buffer offset types

On Tue, 2011-12-20 at 23:46 -0500, David Miller wrote:
> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Wed, 21 Dec 2011 01:32:52 +0000
> 
> > -	dbg(DBG_RX, "In fst_rx_dma %lx %lx %d\n",
> > -	    (unsigned long) skb, (unsigned long) mem, len);
> > +	dbg(DBG_RX, "In fst_rx_dma %x %x %d\n", (u32)skb, mem, len);
> 
> This is more appropriately fixed by using "%p" instead of casting to a 
> 32-bit int.

'skb' is the physical address of the data in the skb.  Whereas 'mem' is the offset of the corresponding buffer in shared memory.

All completely clear, right? ;-)

Ben.

--
Ben Hutchings
Humans are not rational beings; they are rationalising beings.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

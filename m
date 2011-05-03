Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1ECRZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:25:38 -0400
Received: from mdc-mail-out01.ubisoft.com ([216.98.57.107]:46258 "EHLO
	mdc-mail-out01.ubisoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243Ab1ECRZf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:25:35 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 13:25:35 EDT
From: David Hill <david.hill@ubisoft.com>
To: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
        Ben Hutchings <bhutchings@solarflare.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dgiagio@gmail.com" <dgiagio@gmail.com>,
        "dborca@yahoo.com" <dborca@yahoo.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pmcenery@gmail.com" <pmcenery@gmail.com>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date: Tue, 3 May 2011 13:18:39 -0400
Subject: RE: [PATCH] ipheth.c: Enable IP header alignment
Thread-Topic: [PATCH] ipheth.c: Enable IP header alignment
Thread-Index: AcwJs0J3w5yqWT57Rk67pP9VIaQj8gAAsClA
Message-ID: <710D4D6CE160654C87478D18385BB9971BE3FDCA46@MDC-MAIL-CMS01.ubisoft.org>
References: <1304264799.2833.82.camel@localhost>
 <1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
 <1304370274.2833.192.camel@localhost>
 <20110503165751.GA6566@bart.evergreen.loc>
In-Reply-To: <20110503165751.GA6566@bart.evergreen.loc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe I can help on this part.

Git ?

I'm using ubuntu natty ... The part  I'm not sure of is , do I patch ubuntu's kernel or I start from scratch?


-----Original Message-----
From: L. Alberto Giménez [mailto:agimenez@sysvalve.es] 
Sent: 3 mai 2011 12:58
To: Ben Hutchings
Cc: linux-kernel@vger.kernel.org; dgiagio@gmail.com; dborca@yahoo.com; davem@davemloft.net; pmcenery@gmail.com; David Hill; open list:USB SUBSYSTEM; open list:NETWORKING DRIVERS
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment

On Mon, May 02, 2011 at 10:04:34PM +0100, Ben Hutchings wrote:
> So this was using NET_IP_ALIGN as an offset into the URB.  Which was
> totally bogus, as its value has long been architecture-dependent.  The
> code is also claiming to put len bytes but only copying len - delta.
> 
> The correct code would be something like:
> 
> 	if (urb->actual_length <= IPHETH_IP_ALIGN) {
> 		dev->net->stats.rx_length_errors++;
> 		return;
> 	}
> 	len = urb->actual_length - IPHETH_IP_ALIGN;
> 	buf = urb->transfer_buffer + IPHETH_IP_ALIGN;
> 	
> 	dev_alloc_skb(len);
> 	...
> 	memcpy(skb_put(skb, len), buf, len);

Thanks for the response Ben.

I can try to change the code, but I don't own the device anymore. Changing the
code without being able to test it would be walking blindfolded :-/

If upstrem (everyone involved is in CC) can't do it, I can submit the changes
advised by Ben, but I can't warantee anything beyond successful compilation. I
don't think that it would be acceptable here.

Regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1

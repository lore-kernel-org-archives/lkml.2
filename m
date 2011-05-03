Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1ECQ56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:57:58 -0400
Received: from n023010.sys.capside.net ([81.25.117.138]:34146 "EHLO
	n023010.sys.capside.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1ECQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:57:57 -0400
Date: Tue, 3 May 2011 18:57:51 +0200
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, dgiagio@gmail.com, dborca@yahoo.com,
        davem@davemloft.net, pmcenery@gmail.com, david.hill@ubisoft.com,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment
Message-ID: <20110503165751.GA6566@bart.evergreen.loc>
References: <1304264799.2833.82.camel@localhost>
 <1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
 <1304370274.2833.192.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1304370274.2833.192.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

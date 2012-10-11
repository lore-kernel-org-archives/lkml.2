Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170Ab2JKSrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:47:08 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59790 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab2JKSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:47:05 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2012 14:47:05 EDT
Date: Thu, 11 Oct 2012 20:37:04 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Andreas Mohr <andi@lisas.de>, Greg KH <gregkh@linuxfoundation.org>,
        davem@davemloft.net, Michael Leun <lkml20120218@newton.leun.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mcs7830: Fix link state detection
Message-ID: <20121011183704.GA8636@rhlx01.hs-esslingen.de>
References: <201210111233.28652.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210111233.28652.linux@rainbow-software.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 11, 2012 at 12:33:28PM +0200, Ondrej Zary wrote:
>  	u8 *buf = urb->transfer_buffer;
>  	bool link;
> +	struct mcs7830_data *data = mcs7830_get_data(dev);
>  
>  	if (urb->actual_length < 16)
>  		return;

Alternatively could do *data = NULL; and then actually assign after the conditional.
But since the conditional most likely is coldpath
I think your chosen implementation is best.


>  
>  	link = !(buf[1] & 0x20);
>  	if (netif_carrier_ok(dev->net) != link) {

I usually like to introduce helper bools to clearly express the intention
behind things (source code should be readable like a book, yet it all
too often is everything but...).
I.e.
bool link_state_change_detected = (netif_carrier_ok......);
if (bool)

Might be an idea here, too.


The logic behind your counter implementation seems solid to me
(short explanatory comment "track link state several times, to guard against
transient erroneous link state of (some versions of?) this chip"
might have been useful though).

Thank you very much for your patch!

Andreas Mohr

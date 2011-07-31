Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1GaDr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 23:47:58 -0400
Received: from knuth.cs.hmc.edu ([134.173.42.100]:52331 "EHLO knuth.cs.hmc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1GaDrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 23:47:53 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jul 2011 23:47:53 EDT
Date: Sat, 30 Jul 2011 21:41:11 -0600
From: Adam Cozzette <acozzette@cs.hmc.edu>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
Message-ID: <20110731033916.GA7182@[192.168.0.12]>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan>
 <4E318BD0.40202@lwfinger.net>
 <20110730113009.GA2847@redhat.com>
 <20110730113255.GB2847@redhat.com>
 <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301310070.4925@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1107301310070.4925@p34.internal.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 01:10:26PM -0400, Justin Piszcz wrote:
> (This is with the patch provided earlier)
> 
> atom:/usr/src/linux# cd drivers/net/wireless/rt2x00/
> atom:/usr/src/linux/drivers/net/wireless/rt2x00# grep 'memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE)' rt2800lib.c
>         memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE);
> atom:/usr/src/linux/drivers/net/wireless/rt2x00# cat /usr/src/linux/.version
> 2
> atom:/usr/src/linux/drivers/net/wireless/rt2x00# uname -a
> Linux atom 3.0.0 #2 SMP Sat Jul 30 08:34:18 EDT 2011 x86_64 GNU/Linux
> atom:/usr/src/linux/drivers/net/wireless/rt2x00#
> 
> Justin.

The last two images you posted show rt2800_txdone in the stack trace. I couldn't
find any such function in the source and unless I'm mistaken, it was renamed in
commit 8f66bbb5 back in May. Are you sure that the most recent code is what is
actually running when you run into this problem?

-- 
Adam Cozzette
Harvey Mudd College

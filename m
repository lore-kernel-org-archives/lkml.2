Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0KNLwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 06:52:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55092 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab0KNLwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 06:52:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JWdnbg0xLkGE10ktCQxmQm7r8Nk3wWxYxfzor1Abpa5VOfG63s8cBPqlgEtV+A519s
         Iz8z5/LEEk/ZTNmDQjwbqD+YzQ0u6BaX4/D95VmJ5tO9hmezL+VeTm7QnCmRLtX9KWOR
         vQQJWlVQq/eb7ypcFQQiMo+Muqg0PKXq6AMVg=
Subject: Re: [PATCH update 2] firewire: net: throttle TX queue before
 running out of tlabels
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4CDFAB10.5050800@s5r6.in-berlin.de>
References: <tkrat.036c5d10fb83f85d@s5r6.in-berlin.de>
	 <tkrat.39c164e4c52e2fc8@s5r6.in-berlin.de>
	 <tkrat.eaac597cf54bb660@s5r6.in-berlin.de>
	 <tkrat.83117f4523f0d928@s5r6.in-berlin.de>
	 <1289710228.8581.16.camel@maxim-laptop>
	 <4CDFAB10.5050800@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 13:52:12 +0200
Message-ID: <1289735532.24539.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 10:25 +0100, Stefan Richter wrote:
> Maxim Levitsky wrote:
> > In fact after lot of testing I see that original patch, 
> > '[PATCH 4/4] firewire: net: throttle TX queue before running out of
> > tlabels' works the best here.
> > With AR fixes, I don't see even a single fwnet_write_complete error on
> > ether side.
> 
> Well, that version missed that the rx path opened up the tx queue again. I.e.
> it did not work as intended.
> 
> > However the 'update 2' (maybe update 1 too, didn't test), lowers
> > desktop->laptop throughput somewhat.
> > (250 vs 227 Mbits/s). I tested this many times.
> > 
> > Actuall raw troughput possible with UDP stream and ether no throttling
> > or higher packets in flight count (I tested 50/30), it 280 Mbits/s.
> 
> Good, I will test deeper queues with a few different controllers here.  As
> long as we keep a margin to 64 so that other traffic besides IPover1394 still
> has a chance to acquire transaction labels, it's OK.
Just tested the 'update 2' with 8-16 margin. Gives me ~250 Mbits/s TCP
easily, and ~280 Mbit/s UDP. Pretty much the maximum its possible to get
out of this hardware.

> 
> > BTW, I still don't understand fully  why my laptop sends only at 180
> > Mbits/s pretty much always regardless of patches or TCP/UDP.
> 
> If it is not CPU bound, then it is because Ricoh did not optimize the AR DMA
> unit as well as Texas Instruments did.
You mean AT, because in the fast case (desktop->laptop), the TI
transmits and Ricoh receives. In slow case Ricoh receives and TI
transmits.
Anyway speeds of new stack beat the old one by significant margin.

Best regards,
	Maxim Levitsky




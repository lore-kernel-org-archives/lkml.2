Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab0KPDbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:31:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759226Ab0KPDbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:31:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OlyniZ/BjRs/3c9UAYEU1+fyZXwvP85oibfvVqVgkB0yOulr8WssE/nTHmhuqSAj2E
         6MgAU/STa8Ln0y8w6rJ6Ank1yOSMNJE/CNWwxUDMni4H4pMsJSvuQGae/TrCGS9dXid6
         pSXbo+6w1UkJsjugbTuIcTzfcf3Kn8JV+3kUE=
Subject: Re: Remaining problems in firewire-net
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20101115090103.0df0b5ef@stein>
References: <tkrat.036c5d10fb83f85d@s5r6.in-berlin.de>
	 <1289795401.11881.62.camel@maxim-laptop>  <20101115090103.0df0b5ef@stein>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 05:31:15 +0200
Message-ID: <1289878275.16486.57.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 09:01 +0100, Stefan Richter wrote:
> On Nov 15 Maxim Levitsky wrote:
> > That is because 1394 spec specifies that first of all the ISO channel
> > must be allocated from the IRM node. The firewire stack currently just
> > uses hardcoded numbers in two places the ISO is used 
> > (firewire-net, and firedtv)
> > However it has all functions implemented for this.
> 
> This is a bug (missing feature) in firedtv but not in firewire-net. The
> broadcast channel is allocated and reallocated by the bus manager, not
> by an IP-over-1394 user.  But you found that out already, below.
Agree fully.

> 
> Channel allocation and DMA context allocation and control are unrelated
> issues, on the other hand.  One is a higher-level cooperative protocol
> for bus-wide resource management (in which the nodes' roles are defined
> in various different ways by protocols such as AV/C's CMP or by IIDC).
> The other is about hardware control locally in the OHCI bus bridge
> hardware.
> 
> [...]
> > In case of firewire-net, it is simpler, because it uses the broadcast
> > channel, so it only has to find who is the IRM and read its
> > BROADCAST_CHANNEL.
> > 
> > However, I think I need to write a function to query the IRM its
> > broadcast channel, don't think it has one.
> 
> Overkill.  Just leave it as is:
>   1.) We know which number the broadcast channel has.
>   2.) We optimistically assume that a 1394a compliant IRM or bus
>       manager exists and allocated that channel.
> 
> Why introduce entirely unnecessary fragility?
Looking at spec again, indeed 31 the the default broadcast channel, and
probably nobody ever changes it by writing the BROADCAST_CHANNEL.
The BROADCAST_CHANNEL register was actually added in 1394a.


> 
> > Speaking of IRM discovery, the spec says it should be a node with
> > contender bit and largest node id. However, the code in
> > core-topology.c, build_tree seems to take the node that sent the
> > selfID packet last.
> 
> This is because of a monotony rule of how self ID packets arrive during
> self identification phase.
Ah, ok, found this bit in spec too.

Btw, according to spec the firewire appears to be half-duplex.


Also one note I wanted to say in previous mail. but forgot.
The IP over 1394 tells that unicast can also use ISO transactions.
However, it doesn't say how to negotiate the ISO channel number, thus a
logical conclusion is that its not possible to use ISO transactions for
unicast.
Is that right?

Best regards,
	Maxim Levitsky


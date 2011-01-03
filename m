Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1ACJ15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:27:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54910 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1ACJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:27:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Lolmn2vI68wjqM/JkzWli+I1E7eMoPLdmBba3vhCGFWFWtjbjZ3ubdZq0HJWE/Nhah
         vLSuqvIdRXfPaVxUfqLobyxfOFzSnuTXjZ9ccDuRKD72K+j+q2ngQC850siHHippDX+i
         ZEl69E+7cljdLeff38TRtYZShsMAJdc121JJ0=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, netdev@vger.kernel.org,
        shemminger@vyatta.com, daniel.baluta@gmail.com, jochen@jochen.org
In-Reply-To: <1294045732.19666.6.camel@wall-e>
References: <1294007971-18878-1-git-send-email-stefani@seibold.net>
	 <1294008562.2535.263.camel@edumazet-laptop>
	 <1294008917.18963.3.camel@wall-e>
	 <alpine.LNX.2.00.1101022356550.11481@swampdragon.chaosbits.net>
	 <1294045732.19666.6.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 10:27:47 +0100
Message-ID: <1294046867.2892.101.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 janvier 2011 à 10:08 +0100, Stefani Seibold a écrit :

> This will not work for two reasons:
> 
> - First there is no way to detect a dead connection. A connection can
> stay for a very long time without data transfer.
> 
> - Second it will not save against a attack where all communication slots
> will be eaten by an attacker and then new valid connections will be not
> handled.
> 
> The only thing what is possible to make an ioctl call which allows the
> user land client to cancel connections. 
> 
> But this will be in my opinion dead code, because white lists of trusted
> address must be fostered and this will make the upgrading of a
> infrastructure to complicate.
> 
> 

Yep, and as UDP messages can easily spoofed, this means you need more
than a list of trusted addresses. You also need to encapsulate the thing
in an secured layer.

Stefani, your implementation has very litle chance being added in
standard kernel, because it is not correctly layered, or documented.

Copying hundred (thousand ?) of lines from existing code only shows
there is a design error in your proposal. It means every time we have to
make a change in this code, we'll have to do it twice.

SUNRPC uses UDP/TCP sockets, and use callbacks to existing UDP/TCP code,
maybe you should take a look to implement an UDPCP stack in kernel.

For instance, a pure socket API seems not the correct choice for UDPCP,
since a transmit should give a report to user, of frame being
delivered/aknowledged or not to/by the remote side ?

With send(), this means you have only one message in transit, no
asynchronous handling.

At least you forgot to document the API, and restrictions.




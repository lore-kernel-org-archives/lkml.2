Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0KYPSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:18:38 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55248 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0KYPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BGkNWOMJh2iKjVxYVO4wiD3VBhMs13bRjiAMTQGYNeNAH/SQHyz+2jSX1mx3j4ctgR
         TVXjiBd1dawRfUME0K4R3p+6nOVulh4p3adJ0hWs/tZ4aiERE1B+3/S29Lbl77Skxt6i
         4fN54xTbOvMaOCv86QbrGq/2mrIxeB8h8hqP8=
Subject: Re: TCP_MAXSEG vs TCP/generic segmentation offload (tso/gso)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Niels =?ISO-8859-1?Q?M=F6ller?= <nisse@lysator.liu.se>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <nnaakxqw1u.fsf@stalhein.lysator.liu.se>
References: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
	 <1290695253.2858.336.camel@edumazet-laptop>
	 <nnaakxqw1u.fsf@stalhein.lysator.liu.se>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 16:18:31 +0100
Message-ID: <1290698312.2858.341.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 25 novembre 2010 à 16:09 +0100, Niels Möller a écrit :
> Eric Dumazet <eric.dumazet@gmail.com> writes:
> 
> > So... there is no 'bug', unless you trust too much tcpdump output.
> 
> I really expected tcpdump -e to display the actual values in the link
> layer header, including the correct frame size. It's more than a bit
> confusing if that is not the case...
> 
> In the future, I will try to remember to always run tcpdump on a network
> node which (i) is different from the sending one, and (ii) has GRO
> disabled (and hence will discard packets if it has trouble processing
> them all, rather than coalesce them).
> 

Just disable GSO and TSO on sending machine, then tcpdump will show you
individual frames.


> What about the TCP_MAXSEG socket option, should that work? From a quick
> look at driver source code, I could only see the handling of the
> per-interface MTU, no per-socket segment size.

TCP_MAXSEG is certainly not handled in driver layer, but TCP layer.

/* If user gave his TCP_MAXSEG, record it to clamp */
if (tp->rx_opt.user_mss)
	tp->rx_opt.mss_clamp = tp->rx_opt.user_mss;

I believe TCP_MAXSEG is working fine, but GRO/GSO dont care at all :
They coalesce frames whatever their size is.




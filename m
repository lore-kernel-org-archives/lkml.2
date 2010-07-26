Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0GZPU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 11:20:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35582 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0GZPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 11:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WjMNsuzfBNgIz5R8dsO9Y+SImsOv7R6rWBG9Wq3yQC14/AOOuJpvVMZsG+IpZA47Rd
         xvDOgxCpnLPh0XBIGsSQD90JwAHq+8Q1gUjMpzq76/Dir/Taz5cupIl3W0JmC/t8JywR
         INZM6KedcsFUkw36LAhRN+dxGq2SBo4Ofk4DY=
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100726145742.GA4888@swordfish.minsk.epam.com>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
	 <PRbv8sgxY6G.A.UEH.mYYSMB@chimera>
	 <20100726131629.GA4398@swordfish.minsk.epam.com>
	 <1280154873.2899.390.camel@edumazet-laptop>
	 <20100726145742.GA4888@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 17:20:50 +0200
Message-ID: <1280157650.2899.454.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 26 juillet 2010 à 17:57 +0300, Sergey Senozhatsky a écrit :

> 
> Only sending. 
> 
> --
>  PGDEV=/proc/net/pktgen/eth0
>  echo "Configuring $PGDEV"
>  pgset "$COUNT"
>  pgset "$CLONE_SKB"
>  pgset "$PKT_SIZE"
>  pgset "$DELAY"
>  pgset "dst 192.168.x.x"
>  pgset "dst_mac  x:x:x:x:x:x"
> 
>  PGDEV=/proc/net/pktgen/pgctrl
> 
>  echo "Running..."
>  pgset "start"
> --
> 
>  

If you try with a DELAY=3000 (or 5000), what happens ?

Do you have TX pause enabled ? If yes, try to disable pauses.

# ethtool -a eth0
Pause parameters for eth0:
Autonegotiate:	on
RX:		on
TX:		on

# ethtool -A eth0 rx off tx off
# ethtool -a eth0
Pause parameters for eth0:
Autonegotiate:	on
RX:		off
TX:		off




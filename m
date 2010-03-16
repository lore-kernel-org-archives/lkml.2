Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab0CPPUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:20:33 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:55158 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0CPPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:20:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dcvdEr2XZlS2iLUtCxBYIrpwdINGEE8qo8oC+SoXucQKO6TNW5sif2mvT/83gE8AF9
         hMuVsYOW2bACqQOpI7/ktqHUhI5oXFyOfNi1mphE03gAEuKOIpXkS0qbv1npe3IwbZgT
         U9SflcF2nrZswOzgIJQ/CtIVvL0fvhI2ejfJY=
Subject: Re: [PATCH] r8169: Fix rtl8169_rx_interrupt()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, Francois Romieu <romieu@fr.zoreil.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100316151023.GC3332@swordfish.minsk.epam.com>
References: <20100307192305.GA598@elte.hu>
	 <20100308125122.GA11242@redhat.com>
	 <1268686865.2824.4.camel@edumazet-laptop>
	 <1268699602.2824.14.camel@edumazet-laptop>
	 <20100316145914.GB3332@swordfish.minsk.epam.com>
	 <1268751933.3094.45.camel@edumazet-laptop>
	 <20100316151023.GC3332@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 16:20:26 +0100
Message-ID: <1268752826.3094.48.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 16 mars 2010 à 17:10 +0200, Sergey Senozhatsky a écrit :

> [...]
> >> NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> Isn't it r8169 related?
> 

This is tx side which seems blocked for more than 6 seconds.

To really test the patch, you need following setup :

machine A with r8169 NIC, patch applied, receiver of pktgen flood.

machine B with any NIC, preferably a not buggy one, doing the pktgen
flood to machine A

If machine A survives, my patch is tested and ok.

If machine B crashes, we have another problem to investigate



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0IAUiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:38:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61183 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab0IAUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A5K91u7wiSXHpV2uLxnGJxyDIfzMgyiAu1bR8VaIFtKz6V4xZJJ1hMNUbRCKjFP543
         nKRIOkmSpNW+pB4TviYAghOe0ezW650fS3J+ab2/Qm3OoNCCfsSTNZSRvwHxMp2G0k4n
         2FpCDybKv5IXsW1i/vRVeZUzncfCD8mcT6NCM=
Subject: Re: [PATCH 03/10] Use percpu stats
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009011501230.16013@router.home>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	 <1281374816-904-4-git-send-email-ngupta@vflare.org>
	 <alpine.DEB.2.00.1008301114460.10316@router.home>
	 <AANLkTikdhnr12uU8Wp60BygZwH770RBfxyfLNMzUsQje@mail.gmail.com>
	 <1283290106.2198.26.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1008311635100.867@router.home>
	 <1283290878.2198.28.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1009011501230.16013@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 22:38:15 +0200
Message-ID: <1283373495.2484.41.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 septembre 2010 à 15:05 -0500, Christoph Lameter a écrit :

> The problem only exists on 32 bit platforms using 64 bit counters. If you
> would provide this functionality for the fallback case of 64 bit counters
> (here x86) in 32 bit arch code then you could use the this_cpu_*
> operations in all context without your special code being replicated in
> ohter places.
> 
> The additional advantage would be that for the 64bit case you would have
> much faster and more compact code.
> 
> 

My implementation is portable and use existing infrastructure, at the
time it was coded. BTW, its fast on 64bit too. As fast as previous
implementation. No extra code added. Please double check.

If you believe you can do better, please do so.

Of course, we added 64bit network stats to all 32bit arches only because
cost was acceptable. (I say all 32bit arches, because you seem to think
only x86 was the target)

Using this_cpu_{add|res}() fallback using atomic ops or spinlocks would
be slower than actual implemenation (smp_wmb() (nops on x86) and
increments).




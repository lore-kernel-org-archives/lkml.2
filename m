Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1CPT0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:26:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45447 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab1CPT0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ow7FVVS7sqUztQZr8TPvE7Jd9wAIGiQvMnaFN0mCVhIDQNZGpHAeyPxXHH3MU8KXEc
         qBNGDBrNrB/sBfdQTIewx53lkym1KPKAlRwmtIVQ4ge3tW3d6TooQJxWw4Xj5VpRCCvO
         yubdveWdPMCoKVXg32z2ewoGjkfR1GXj3BJYA=
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Hugh Dickins <hughd@google.com>, George Spelvin <linux@horizon.com>,
        penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1300299787.3128.495.camel@calx>
References: <20110316022804.27679.qmail@science.horizon.com>
	 <alpine.LSU.2.00.1103161011370.13407@sister.anvils>
	 <1300299787.3128.495.camel@calx>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 20:26:33 +0100
Message-ID: <1300303593.3202.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think this alignment exists to minimize the number of cacheline
> bounces on SMP as this can be a pretty hot structure in the network
> stack. It could probably benefit from a per-cpu treatment.
> 

Well, this is a mostly read area of memory, dirtied every 5 minutes.

Compare this to 'jiffies' for example ;)

What could be done is to embed 'ip_cnt' inside ip_keydata[0] for
example, to avoid wasting a cache line for one bit ;)


c1606c40 b ip_cnt
<hole>
c1606c80 b ip_keydata



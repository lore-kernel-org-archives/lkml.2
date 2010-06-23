Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0FWRIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:08:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54358 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0FWRIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eA96pHkno0i46v+JdG2RAHE6EUJuDp3ikyqFroQRTJhAPY/4zgirD1B7+dgiix0lHo
         FC/aW0MmHjmlI06olwWIe4px/mIs6wRZu/hRM+NTuLrR/ej1ruW+N30Z8ga/EUsBLmna
         UPhro6ggIc1nSdWPn3NHgdoOQN23BqYOk5b+I=
Message-ID: <4C223DCA.5090704@gmail.com>
Date: Wed, 23 Jun 2010 10:00:58 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, timo.teras@iki.fi
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
References: <AANLkTilf41JrFwN1veRDifNA78S2LQ6SO0g3YLOONd2W@mail.gmail.com> <20100623141622.GC15205@tuxdriver.com>
In-Reply-To: <20100623141622.GC15205@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. the bisect is pointing to the below results..
(I tried git revert xxx but this commit is too big
so I'll(hopefully)manually revert it on the latest HEAD to
see if this is the actual problem im experiencing)



80c802f3073e84c956846e921e8a0b02dfa3755f is the first bad commit
commit 80c802f3073e84c956846e921e8a0b02dfa3755f
Author: Timo Teräs <timo.teras@iki.fi>
Date:   Wed Apr 7 00:30:05 2010 +0000

     xfrm: cache bundles instead of policies for outgoing flows

     __xfrm_lookup() is called for each packet transmitted out of
     system. The xfrm_find_bundle() does a linear search which can
     kill system performance depending on how many bundles are
     required per policy.

     This modifies __xfrm_lookup() to store bundles directly in
     the flow cache. If we did not get a hit, we just create a new
     bundle instead of doing slow search. This means that we can now
     get multiple xfrm_dst's for same flow (on per-cpu basis).

     Signed-off-by: Timo Teras <timo.teras@iki.fi>
     Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 d8e60f5fa4c1329f450d9c7cdf98b34e6a177f22 
9f576e68e5bf4ce357d7f0305aee5f410250dfe2 M      include
:040000 040000 f2876df688ee36907af7b4123eea96592faaed3e 
a3f6f6f94f0309106856cd99b38ec90b024eb016 M      net



Justin P. Mattock

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1CUULF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:11:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64840 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1CUULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OJ9YfQxNUjmlwSPherAEMlRhCsyduYwsMzQIoTTXDhOogcjlZBP0Yq1hrEC857rNT5
         eOXGndUq01GMOVAkgOLr59PUKllXyhK54RgICVYINqlX8H8gP84PmpjjhyDgTseUunVS
         eYVufmXLsX5JFEQHDM7wV9JxaQpI1cFWxY/h8=
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinN3qszBjbJdkXb2TPBkAW0mXGC=Ri1zKL9gdNg@mail.gmail.com>
References: <20110320.195156.226769634.davem@davemloft.net>
	 <AANLkTinN3qszBjbJdkXb2TPBkAW0mXGC=Ri1zKL9gdNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 21:10:55 +0100
Message-ID: <1300738255.2837.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 mars 2011 à 12:24 -0700, Linus Torvalds a écrit :
> On Sun, Mar 20, 2011 at 7:51 PM, David Miller <davem@davemloft.net> wrote:
> >
> > 1) The R8169 PHY fix from Eric Dumazet, which I see you've added to
> >   your tree too. :-)
> 
> Yeah, since my machine didn't have networking without it, and I could
> test it myself, I didn't wait to pull.
> 
> That said, I'm delaying this pull request due to the known issues with
> it - let me know when you've updated it with the fix for the
> use-after-free fixes and the slab corruptor (the latter of which I
> haven't seen a patch for yet)

Seems to be related to one typo, but still we have to find the
corruption

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index b799cea..33733c8 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3605,7 +3605,7 @@ int __net_init __ip_vs_control_init(struct net *net)
 
 	/* procfs stats */
 	ipvs->tot_stats.cpustats = alloc_percpu(struct ip_vs_cpu_stats);
-	if (ipvs->tot_stats.cpustats) {
+	if (!ipvs->tot_stats.cpustats) {
 		pr_err("%s(): alloc_percpu.\n", __func__);
 		return -ENOMEM;
 	}



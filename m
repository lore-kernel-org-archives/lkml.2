Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1ERUUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:20:31 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:58140 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752316Ab1ERUU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:20:28 -0400
Date: Wed, 18 May 2011 22:20:25 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: David Miller <davem@davemloft.net>
Cc: tsunanet@gmail.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
Message-ID: <20110518202025.GC4175@nuttenaction>
References: <1305715384-81716-1-git-send-email-tsunanet@gmail.com>
 <20110518.152653.1486764697527722925.davem@davemloft.net>
 <BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
 <20110518.155200.801089483916944725.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518.155200.801089483916944725.davem@davemloft.net>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller | 2011-05-18 15:52:00 [-0400]:

>I've already changed the initial TCP congestion window in Linux to 10
>without some stupid draft being fully accepted.
>
>I'll just as easily accept right now a patch right now which lowers
>the initial RTO to 1 second and adds the 3 second RTO fallback.

I like the idea to make the initial RTO a knob because we in a isolated MANET
environment have a RTT larger then 1 second. Especially the link layer setup
procedure over several hops demand some time-costly setup time. After that the
RTT is <1 second. The current algorithm works great for us. So this RTO change
will be counterproductive: it will always trigger a needless timeout.

The main problem for us is that Google at all pushing their view of Internet
with a lot of pressure. The same is true for the IETF IW adjustments, which is
unsuitable for networks which operates at a bandwidth characteristic some
years ago. The _former_ conservative principle "TCP over everything" is
forgotten.

Hagen

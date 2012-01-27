Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2A0OSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:18:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2A0OSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:18:12 -0500
Date: Fri, 27 Jan 2012 15:17:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <glommer@parallels.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [v3.3-rc1 regression] TCP: too many of orphaned sockets
Message-ID: <20120127141754.GA30202@elte.hu>
References: <20120127124641.GA30819@elte.hu>
 <4F229D5C.4040300@parallels.com>
 <20120127125645.GA28131@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127125645.GA28131@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ok, i've bisected it, and the bad commit is:

3dc43e3e4d0b52197d3205214fe8f162f9e0c334 is the first bad commit
commit 3dc43e3e4d0b52197d3205214fe8f162f9e0c334
Author: Glauber Costa <glommer@parallels.com>
Date:   Sun Dec 11 21:47:05 2011 +0000

    per-netns ipv4 sysctl_tcp_mem
    
    This patch allows each namespace to independently set up
    its levels for tcp memory pressure thresholds. This patch
    alone does not buy much: we need to make this values
    per group of process somehow. This is achieved in the
    patches that follows in this patchset.
    
    Signed-off-by: Glauber Costa <glommer@parallels.com>
    Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    CC: David S. Miller <davem@davemloft.net>
    CC: Eric W. Biederman <ebiederm@xmission.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks,

	Ingo

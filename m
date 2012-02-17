Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2BQJup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:50:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64229 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2BQJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:50:43 -0500
Message-ID: <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: TCP_STREAM performance regression on commit b3613118
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: davem@davemloft.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@intel.com>, "Huang, Ying" <ying.huang@intel.com>
Date: Fri, 17 Feb 2012 10:50:39 +0100
In-Reply-To: <1329466694.12669.2976.camel@debian>
References: <1329466694.12669.2976.camel@debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 17 février 2012 à 16:18 +0800, Alex,Shi a écrit :
> The tcp_stream loop back performance has about 10% drop on the
> commitment on our core2 2 sockets server. This commit has 2
> parents(7505afe28, 5983fe), but both of them have no regression. So
> guess the impact just happened when this 2 parents joint. That beyond
> our capability to dig it more.
> 
> Any ideas? 

Most probably the more accurate truesize determination is responsible of
this tcp regression, since some prior assumptions might be wrong.

Want to give more information on the workload ?
Is it a 32 or 64 bit kernel ?

cat /proc/sys/net/ipv4/tcp_rmem
cat /proc/sys/net/ipv4/tcp_wmem
netstat -s



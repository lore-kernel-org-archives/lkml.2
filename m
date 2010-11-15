Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab0KOUBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:01:18 -0500
Received: from minus.inr.ac.ru ([194.67.69.97]:37316 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756336Ab0KOUBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:01:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=P1lVSdSK7Z7NE75lZCsO4enJi05f5EFTL4GNFd8hgmPT/EiIlbR9Jv+Pf3S6Cm3ZKxzYY2RDD/iLYxHT91loSN6bwVSaRAXl2U++1Wqv9l63CRKMpg31JRJXTL1dCIs5lNd6USG0TzrYypVHdle2VAfBhLCFn3cLej5yZNmdlPQ=;
Date: Mon, 15 Nov 2010 23:00:30 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Eric Paris <eparis@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>, Hua Zhong <hzhong@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org
Subject: Re: [RFC PATCH] network: return errors if we know tcp_connect failed
Message-ID: <20101115200030.GA14551@ms2.inr.ac.ru>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com> <00c201cb81eb$84e18160$8ea48420$@com> <4CDCEE65.3060105@trash.net> <017301cb82bf$54540cf0$fcfc26d0$@com> <4CE10C2A.1050801@trash.net> <1289836066.14282.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289836066.14282.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Mon, Nov 15, 2010 at 10:47:46AM -0500, Eric Paris wrote:
> Well I'm (I guess?) surprised that the --reject-with icmp doesn't do
> anything with a local outgoing connection

Yeah. This was "an obvious surpise": for local socket the first icmp error always
arrives on locked socket and gets dropped. I even forgot about this (tcp-reset
still works ok due to backlog) This makes the idea to respect error more attractive.

Alexey

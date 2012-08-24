Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2HXOtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:49:09 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46702 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab2HXOtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:49:07 -0400
Date: Fri, 24 Aug 2012 09:48:52 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adobriyan@gmail.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
Message-ID: <20120824144852.GA18850@gulag1.americas.sgi.com>
References: <1345653510-22000-1-git-send-email-nzimmer@sgi.com> <1345660110.5158.1969.camel@edumazet-glaptop> <1345671778.5158.2369.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345671778.5158.2369.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:42:58PM +0200, Eric Dumazet wrote:
> On Wed, 2012-08-22 at 20:28 +0200, Eric Dumazet wrote:
> 
> > 
> > Thats interesting, but if you really want this to fly, one RCU
> > conversion would be much better ;)
> > 
> > pde_users would be an atomic_t and you would avoid the spinlock
> > contention.
> 
> Here is what I had in mind, I would be interested to know how it helps a 512 core machine ;)
> 

Here are the results and they look great.

cpuinfo	baseline	moved kfree	Rcu 
tasks	read-sec	read-sec	read-sec
1	0.0141		0.0141		0.0141
2	0.0140		0.0140		0.0142
4	0.0140		0.0141		0.0141
8	0.0145		0.0145		0.0140
16	0.0553		0.0548		0.0168
32	0.1688		0.1622		0.0549
64	0.5017		0.3856		0.1690
128	1.7005		0.9710		0.5038
256	5.2513		2.6519		2.0804
512	8.0529		6.2976		3.0162




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2JEOvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:51:03 -0400
Received: from ns.iliad.fr ([212.27.33.1]:55126 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab2JEOvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:51:01 -0400
Message-ID: <1349448659.28867.27.camel@sakura.staff.proxad.net>
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109
 __alloc_pages_nodemask+0x1d4/0x68c()
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Madore <david+ml@madore.org>, Francois Romieu <romieu@fr.zoreil.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Date: Fri, 05 Oct 2012 16:50:59 +0200
In-Reply-To: <1349442173.21172.66.camel@edumazet-glaptop>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
	 <alpine.LSU.2.00.1208311900330.1936@eggly.anvils>
	 <1349366521.2532.12.camel@sakura.staff.proxad.net>
	 <1349368171.16011.79.camel@edumazet-glaptop>
	 <1349422868.21172.38.camel@edumazet-glaptop>
	 <1349434194.16710.44.camel@sakura.staff.proxad.net>
	 <1349439732.21172.52.camel@edumazet-glaptop>
	 <1349441509.28867.17.camel@sakura.staff.proxad.net>
	 <1349442173.21172.66.camel@edumazet-glaptop>
Organization: Freebox
Content-Type: text/plain; charset="ANSI_X3.4-1968"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2012-10-05 at 15:02 +0200, Eric Dumazet wrote:

> On Fri, 2012-10-05 at 14:51 +0200, Maxime Bizon wrote:
> 
> > > New convention would be : pass number of needed bytes after current
> > > tail, not after current end.
> > 
> > Fully agree on this
> > 
> 
> Here is the proposal :

Looks fine

What is your plan for the actual pskb_expand_head() code now that you
will have absolute values for headroom & tailroom ?

Because there will still be callers that have no clue of required
tailroom (nor further headroom requirement), like skb_cow() in
vlan_reorder_header().

-- 
Maxime



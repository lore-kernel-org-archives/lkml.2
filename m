Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab0J1VJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:09:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758423Ab0J1VJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:09:18 -0400
Date: Thu, 28 Oct 2010 14:07:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] numa: fix slab_node(MPOL_BIND)
Message-Id: <20101028140725.755aea50.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1010281154150.26782@router.home>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	<1288158182-1753-1-git-send-email-brgerst@gmail.com>
	<1288159670.2652.181.camel@edumazet-laptop>
	<1288173442.15336.1490.camel@twins>
	<1288186405.2709.117.camel@edumazet-laptop>
	<4CC82C2F.1020707@kernel.org>
	<1288187870.2709.128.camel@edumazet-laptop>
	<4CC83067.5000009@kernel.org>
	<1288189461.2709.144.camel@edumazet-laptop>
	<1288190387.2709.147.camel@edumazet-laptop>
	<4CC83A85.3070608@kernel.org>
	<1288192868.2709.152.camel@edumazet-laptop>
	<4CC846D5.50106@kernel.org>
	<1288195668.2709.167.camel@edumazet-laptop>
	<1288200823.5619.46.camel@edumazet-laptop>
	<AANLkTikmNc7qqDzoff_3i_FRbG=pmOC7TG3eeZnmvaTD@mail.gmail.com>
	<alpine.DEB.2.00.1010281154150.26782@router.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010 11:55:18 -0500 (CDT)
Christoph Lameter <cl@linux.com> wrote:

> On Thu, 28 Oct 2010, Linus Torvalds wrote:
> 
> > And so does - although less obviously - mm/vmscan.c for the
> > wait_iff_confgested() thing.
> >
> > So are those buggy too, since first_zones_zonelist() can apparently return NULL?
> 
> The code is fine.
> 
> first_zones_zonelist() can only return NULL for the case that a nodemask
> was specified and the code in vmscan.c does not specify a nodemask.

Geeze, how did you work that out and how the heck was anyone else
supposed to know this :(


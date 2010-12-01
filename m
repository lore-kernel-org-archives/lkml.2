Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0LAKRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:17:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48704 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0LAKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:17:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Simon Kirby <sim@hostway.ca>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1011301309240.3134@router.home>
References: <20101130092534.82D5.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011301309240.3134@router.home>
Message-Id: <20101201114226.ABAB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 19:17:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 30 Nov 2010, KOSAKI Motohiro wrote:
> 
> > This?
> 
> Specifying a parameter to temporarily override to see if this has the
> effect is ok. But this has worked for years now. There must be something
> else going with with reclaim that causes these issues now.

I don't think this has worked. Simon have found the corner case recently,
but it is not new.

So I hope you realize that high order allocation is no free lunch. __GFP_NORETRY
makes no sense really. Even though we have compaction, high order reclaim is still
costly operation.

I don't think SLUB's high order allocation trying is bad idea. but now It 
does more costly trying. that's bad. Also I'm worry about SLUB assume too 
higher end machine. Now Both SLES and RHEL decided to don't use SLUB, 
instead use SLAB. Now linux community is fragmented. If you are still 
interesting SL*B unification, can you please consider to join corner 
case smashing activity?




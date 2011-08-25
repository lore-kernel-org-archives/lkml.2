Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1HYXB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:01:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40889 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1HYXB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:01:56 -0400
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
From: Peter Zijlstra <peterz@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Date: Fri, 26 Aug 2011 01:01:37 +0200
In-Reply-To: <1314300546.3268.8.camel@mulgrave>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>
	 <20110818144025.8e122a67.akpm@linux-foundation.org>
	 <1314284272.27911.32.camel@twins>
	 <alpine.DEB.2.00.1108251009120.27407@router.home>
	 <1314289208.3268.4.camel@mulgrave>
	 <alpine.DEB.2.00.1108251128460.27407@router.home>
	 <986ca4ed-6810-426f-b32f-5c8687e3a10b@email.android.com>
	 <alpine.DEB.2.00.1108251206440.27407@router.home>
	 <1e295500-5d1f-45dd-aa5b-3d2da2cf1a62@email.android.com>
	 <alpine.DEB.2.00.1108251341230.27407@router.home>
	 <1314300546.3268.8.camel@mulgrave>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314313297.26922.17.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 12:29 -0700, James Bottomley wrote:
> 
> Therefore from the risc point of view, most of the this_cpu_xxx
> operations are things that we don't really care about except that the
> result would be easier to read in C. 

Right, so the current fallback case is pretty much the optimal case for
the RISC machines, which ends up with generic code being better off not
using it much and instead preferring __this_cpu if there's more than
one.

I mean, its absolutely awesome these things are 1 instruction on x86,
but if we pessimize all other 20-odd architectures its just not cool.


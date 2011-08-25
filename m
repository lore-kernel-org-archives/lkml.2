Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1HYTFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:05:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46464 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab1HYTFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:05:35 -0400
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: James Bottomley <James.bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Date: Thu, 25 Aug 2011 21:05:15 +0200
In-Reply-To: <alpine.DEB.2.00.1108251341230.27407@router.home>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314299115.26922.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 13:46 -0500, Christoph Lameter wrote:
> 
> RISC cpus have instruction to construct complex atomic actions by the cpu
> as I have shown before for ARM. 

Also, I thought this_cpu thing's were at best locally atomic. If you
make them full blown atomic ops then even __this_cpu ops will have to be
full atomic ops, otherwise:


CPU0			CPU(1)

this_cpu_inc(&foo);	preempt_disable();
			__this_cpu_inc(&foo);
			preempt_enable();

might step on each other's toes.

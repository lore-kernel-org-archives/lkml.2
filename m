Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab1ESIf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:35:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:44888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1ESIfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:35:25 -0400
Subject: Re: [PATCH v2 1/2] rcu: don't bind offline cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: yong.zhang0@gmail.com, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        lizf@cn.fujitsu.com, miaox@cn.fujitsu.com
In-Reply-To: <4DD4B358.3080705@jp.fujitsu.com>
References: <20110428161149.GA15658@redhat.com>
	 <20110502194416.2D61.A69D9226@jp.fujitsu.com>
	 <20110502195657.2D68.A69D9226@jp.fujitsu.com>
	 <1305129929.2914.247.camel@laptop> <4DCCC61F.80408@jp.fujitsu.com>
	 <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
	 <20110515185547.GL2258@linux.vnet.ibm.com> <20110516132623.GA2058@zhy>
	 <4DD4B358.3080705@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 May 2011 10:34:38 +0200
Message-ID: <1305794078.2466.7193.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 15:06 +0900, KOSAKI Motohiro wrote:
> 
> The right way is, explicit two phase cpu bindings (1) bind boot
> (or any other online) cpu at CPU_UP_PREPARE (2) bind correct
> target cpu at CPU_ONLINE. This patch does it. 

I'm not sure that is in-fact correct. From what I understood, RCU could
have need of this thread before the ONLINE callback and expects it to be
affine at that time.

What was wrong with delaying the wakeup to STARTING?

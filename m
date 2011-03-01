Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab1CAIVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:21:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43843 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab1CAIVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:21:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o1JANHNWjq2c8BQPOFL5a647iroQeQ9VEP1qICwDatEOKXjkGaY+/vFt5sFgKYmnpz
         /bmq6wzd4YqoO2pkwrVDWowipWC0tEely5nTvSRjysxCL/pnD2BlqltWOnU8xY3LfoIX
         s1jenFNLJxp+nMyjJp2pxLBuLROL9vK1WMxgw=
Subject: Re: [PATCH 4/4] net,rcu: don't assume the size of struct rcu_head
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20110301.001638.104075130.davem@davemloft.net>
References: <4D6CA860.3020409@cn.fujitsu.com>
	 <20110301.001638.104075130.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 09:20:55 +0100
Message-ID: <1298967655.2676.66.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 00:16 -0800, David Miller a écrit :
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Tue, 01 Mar 2011 16:03:44 +0800
> 
> > 
> > struct dst_entry assumes the size of struct rcu_head as 2 * sizeof(long)
> > and manually adds pads for aligning for "__refcnt".
> > 
> > When the size of struct rcu_head is changed, these manual padding
> > is wrong. Use __attribute__((aligned (64))) instead.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> We don't want to use the align if it's going to waste lots of space.
> 
> Instead we want to rearrange the structure so that the alignment comes
> more cheaply.

Oh well, I should have read your answer before sending mine :)




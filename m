Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1CANAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 08:00:05 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52580 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1CANAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 08:00:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=doExVdNJnrI2E49ugNNKoljRQaVOitdDncW0I2kRVWTB0H28VaC6SbWnA2EqyURy21
         bIljqcPwckgpXgI0E2VatbjKDaXz3xSks1dOSq7H2iR1oKhWZJWVmgSqYvGHDmCylVLQ
         0JPuDYSAcZYGmFYfDVOI7P+k4u/gMsEzyEn2w=
MIME-Version: 1.0
In-Reply-To: <4D6CA852.3060303@cn.fujitsu.com>
References: <4D6CA852.3060303@cn.fujitsu.com>
Date: Tue, 1 Mar 2011 15:00:02 +0200
X-Google-Sender-Auth: 9SSBwsYnGBmCOHRJU55IRsLODoM
Message-ID: <AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com>
Subject: Re: [PATCH 2/4] slub,rcu: don't assume the size of struct rcu_head
From: Pekka Enberg <penberg@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 10:03 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> The size of struct rcu_head may be changed. When it becomes larger,
> it will pollute the page array.
>
> We reserve some some bytes for struct rcu_head when a slab
> is allocated in this situation.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

The SLAB and SLUB patches are fine by me if there are going to be real
users for this. Christoph, Paul?

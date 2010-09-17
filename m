Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0IQGws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 02:52:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48521
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab0IQGwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 02:52:47 -0400
Date: Thu, 16 Sep 2010 23:53:05 -0700 (PDT)
Message-Id: <20100916.235305.233408955.davem@davemloft.net>
To: w@1wt.eu
Cc: drosenberg@vsecurity.com, security@kernel.org, grundler@parisc-linux.org,
        netdev@vger.kernel.org, jeffm@suse.com, linux-kernel@vger.kernel.org,
        kyle@mcmartin.ca
Subject: Re: [Security] [PATCH v4] drivers/net/tulip/de4x5.c: fix union
 member name in DE4X5_GET_REG ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100917063602.GA2341@1wt.eu>
References: <1284701436.2565.6.camel@dan>
	<20100916.223441.93463391.davem@davemloft.net>
	<20100917063602.GA2341@1wt.eu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Fri, 17 Sep 2010 08:36:02 +0200

> On Thu, Sep 16, 2010 at 10:34:41PM -0700, David Miller wrote:
>> From: Dan Rosenberg <drosenberg@vsecurity.com>
>> Date: Fri, 17 Sep 2010 01:30:36 -0400
>> 
>> > Tiring doesn't begin to describe it.  Formatting undamaged.
>> 
>> :-)  Thanks.
>> 
>> > This was previously reported as a security issue due to leakage of
>> > uninitialized stack memory.  Jeff Mahoney pointed out that this is
>> > incorrect since the copied data is from a union (rather than a struct).
>> > Therefore, this patch is only under consideration for the sake of
>> > correctness, and is not security relevant. 
>> > 
>> > Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
>> > Acked-by: Grant Grundler <grundler@parisc-linux.org>
>> 
>> Applied.
> 
> David, just for the record, as was already reported on the list, this
> fix is finally more a cleanup than a security fix because "tmp" is a
> union and not a struct, so tmp.addr == tmp.lval.

I can read, thanks :-)

That's why I applied it to net-next-2.6 and not net-2.6

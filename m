Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0IQGgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 02:36:53 -0400
Received: from 1wt.eu ([62.212.114.60]:45037 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0IQGgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 02:36:51 -0400
Date: Fri, 17 Sep 2010 08:36:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Miller <davem@davemloft.net>
Cc: drosenberg@vsecurity.com, security@kernel.org, grundler@parisc-linux.org,
        netdev@vger.kernel.org, jeffm@suse.com, linux-kernel@vger.kernel.org,
        kyle@mcmartin.ca
Subject: Re: [Security] [PATCH v4] drivers/net/tulip/de4x5.c: fix union member name in DE4X5_GET_REG ioctl
Message-ID: <20100917063602.GA2341@1wt.eu>
References: <1284699944.2565.4.camel@dan> <20100916.222740.135972127.davem@davemloft.net> <1284701436.2565.6.camel@dan> <20100916.223441.93463391.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916.223441.93463391.davem@davemloft.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:34:41PM -0700, David Miller wrote:
> From: Dan Rosenberg <drosenberg@vsecurity.com>
> Date: Fri, 17 Sep 2010 01:30:36 -0400
> 
> > Tiring doesn't begin to describe it.  Formatting undamaged.
> 
> :-)  Thanks.
> 
> > This was previously reported as a security issue due to leakage of
> > uninitialized stack memory.  Jeff Mahoney pointed out that this is
> > incorrect since the copied data is from a union (rather than a struct).
> > Therefore, this patch is only under consideration for the sake of
> > correctness, and is not security relevant. 
> > 
> > Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> > Acked-by: Grant Grundler <grundler@parisc-linux.org>
> 
> Applied.

David, just for the record, as was already reported on the list, this
fix is finally more a cleanup than a security fix because "tmp" is a
union and not a struct, so tmp.addr == tmp.lval.

Regards,
Willy


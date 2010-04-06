Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0DFDW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 23:22:59 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46034 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0DFDWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 23:22:53 -0400
Date: Tue, 6 Apr 2010 13:22:49 +1000
From: Simon Horman <horms@verge.net.au>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
       Julian Anastasov <ja@ssi.bg>, netdev@vger.kernel.org,
       lvs-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] IPVS: replace sprintf to snprintf to avoid stack
 buffer overflow
Message-ID: <20100406032248.GF30359@verge.net.au>
References: <20100406025020.GA2741@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406025020.GA2741@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:50:20AM +0800, wzt.wzt@gmail.com wrote:
> IPVS not check the length of pp->name, use sprintf will cause stack buffer overflow.
> struct ip_vs_protocol{} declare name as char *, if register a protocol as:
> struct ip_vs_protocol ip_vs_test = {
>         .name =			"aaaaaaaa....128...aaa",
> 	.debug_packet =         ip_vs_tcpudp_debug_packet,
> };
> 
> when called ip_vs_tcpudp_debug_packet(), sprintf(buf, "%s TRUNCATED", pp->name); 
> will cause stack buffer overflow.
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

I think that the simple answer is, don't do that.
But your patch seems entirely reasonable to me.

Acked-by: Simon Horman <horms@verge.net.au>

Patrick, please consider merging this.


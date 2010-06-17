Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0FQBFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:05:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56259
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab0FQBF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:05:29 -0400
Date: Wed, 16 Jun 2010 18:05:40 -0700 (PDT)
Message-Id: <20100616.180540.116379677.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: ossthema@de.ibm.com, netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, tklein@linux.ibm.com, adetsch@br.ibm.com,
       themann@de.ibm.com
Subject: Re: [PATCH 1/2] ehea: fix delayed packet processing
From: David Miller <davem@davemloft.net>
In-Reply-To: <6663.1276620347@death.nxdomain.ibm.com>
References: <201006151735.17258.ossthema@de.ibm.com>
	<6663.1276620347@death.nxdomain.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Tue, 15 Jun 2010 09:45:47 -0700

> Jan-Bernd Themann <ossthema@de.ibm.com> wrote:
> 
>>In the eHEA poll function an rmb() is required. Without that some packets
>>on the receive queue are not seen and thus delayed until the next interrupt
>>is handled for the same receive queue.
>>
>>Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> 
> 	To add a bit of background, this could manifest during a netperf
> TCP_RR or UDP_RR on an otherwise idle network.  TCP would occasionally
> retransmit, but then both the original segment and the retransmission
> would simultaneously appear at the receiver.  For UDP_RR, message sizes
> in excess of the mtu would occasionally "lose" an IP fragment, and
> eventually IP reassembly would time out.
> 
> 	-J
> 
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

Applied.

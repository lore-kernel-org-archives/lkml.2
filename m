Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab0JSNUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:20:12 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2354 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab0JSNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:20:10 -0400
Date: Tue, 19 Oct 2010 10:19:36 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, paul.gortmaker@windriver.com,
        jon.maloy@ericsson.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes
Message-ID: <20101019131936.GB8781@llucax.com.ar>
References: <4CBCD429.8090306@windriver.com>
 <20101018234547.GA5703@hmsreliant.think-freely.org>
 <20101019021657.GZ8781@llucax.com.ar>
 <20101019.011649.71113115.davem@davemloft.net>
 <20101019110452.GA14410@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101019110452.GA14410@hmsreliant.think-freely.org>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman, el 19 de octubre a las 07:04 me escribiste:
> On Tue, Oct 19, 2010 at 01:16:49AM -0700, David Miller wrote:
> > From: Leandro Lucarella <luca@llucax.com.ar>
> > Date: Mon, 18 Oct 2010 23:16:57 -0300
> > 
> > > 
> > > The problem is not between the tipc stacks in different hosts, is
> > > between the tipc stack and the applications using it (well, maybe
> > > there is a problem somewhere else too).
> > > 
> > > This was a deliberate API change, not a subtle bug...
> > 
> > Neil et al., if these packets live only between the kernel stack
> > and the userspace API layer, we should not be byte-swapping this
> > stuff and we need to fix this fast.
> > 
> Copy that Dave.  I think I see the problem.  The subscription code handles
> messages both off the wire and from local user space.  The off the wire case
> should work because the subscription code assumes that all the incomming data is
> in network byte order, but user space is an exception to that rule as its in
> local byte order.  I'll have a patch together for Leandro to test soon.
> Neil

Thank you very much. Bare in mind that the byte order is just one of the
problems, the other problem is the change in the value of
TIPC_SUB_SERVICE from 2 to 0. That too is breaking the API/ABI, as
a message with a filter value of 2 is rejected by TIPC 2.0/2.6.35+.

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
Dentro de 30 años Argentina va a ser un gran supermercado con 15
changuitos, porque esa va a ser la cantidad de gente que va a poder
comprar algo.
	-- Sidharta Wiki

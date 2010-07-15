Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab0GOMFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 08:05:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48824 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab0GOMFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 08:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LXiw3po7vmK7QIHWnhmPCnPm76Q3xNKX1h/jdp48AqrVCb+yAweI7hqxQJNAoREC5c
         OE4cwI7ZvX6hnOBq0JTJ6xcQingSZugVJ1NPLrdVAf3/6g8nyk9nwNSJAM3bTZZJNKtm
         KW0n8VkTNXcGhal4rOGnyvfN3Ml7yyXwPLqJk=
Subject: Re: oops in tcp_xmit_retransmit_queue() w/ v2.6.32.15
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
Cc: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
In-Reply-To: <4C3EF7EA.2040900@nets.rwth-aachen.de>
References: <4C358AAA.9080400@kernel.org>
	 <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi>
	 <4C3EF7EA.2040900@nets.rwth-aachen.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Jul 2010 14:05:28 +0200
Message-ID: <1279195528.2496.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 15 juillet 2010 à 13:58 +0200, Lennart Schulte a écrit :
> I'm testing new reordering algorithms in a virtual testbed, that is the 
> nodes are emulated with xen and all the network parameters can be tuned 
> with queues.
> With one of the algorithms I also got tracebacks which include 
> tcp_xmit_retransmit_queue. It only happens with ACK loss. The kernel 
> version however is 2.6.31.
> When I read this thread I tried the debug patch and got the following:
> 
> [ 2754.413150] NULL head, pkts 0
> [ 2754.413156] Errors caught so far 1
> 
> Hope that is of any help.

Not sure I understand. 

Are you saying you reproduce same tcp_xmit_retransmit_queue()  bug, with
a special tc qdisc/class droppping some ACK frames ?

Could it be some sched problem and incorrect return codes in case of
congestion ?



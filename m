Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab0GSRjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:39:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60583 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760783Ab0GSRjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WZumzJPsohJeomXA46wktQ3pryUZxEvHpkdmu5z5fWgAFPO8XPI8VJl8lZn2vU+niG
         ZLecEwq5clOWqyPcsDB7ZGzVo3l3t0LwKgEp/YG0vgQYFUmhTllwgin43giBg2YDfLGQ
         RHrTYrbgTG2rk7b2a6ZkTBlIetbjEvu/fXCcg=
Subject: Re: [PATCHv2] tcp: fix crash in tcp_xmit_retransmit_queue
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
In-Reply-To: <alpine.DEB.2.00.1007192013010.30181@melkinpaasi.cs.helsinki.fi>
References: <4C358AAA.9080400@kernel.org>
	 <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi>
	 <4C3EF7EA.2040900@nets.rwth-aachen.de>
	 <1279195528.2496.2.camel@edumazet-laptop>
	 <4C3F053F.7090704@nets.rwth-aachen.de>
	 <alpine.DEB.2.00.1007161448330.13946@melkinpaasi.cs.helsinki.fi>
	 <4C404FC5.6040107@nets.rwth-aachen.de>
	 <alpine.DEB.2.00.1007161602510.13946@melkinpaasi.cs.helsinki.fi>
	 <4C440771.7080107@nets.rwth-aachen.de>
	 <alpine.DEB.2.00.1007191319010.13002@wel-95.cs.helsinki.fi>
	 <1279548555.2553.51.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1007192013010.30181@melkinpaasi.cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 19:39:08 +0200
Message-ID: <1279561148.2553.150.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 19 juillet 2010 à 20:25 +0300, Ilpo Järvinen a écrit :

> This difference is well thought and intentional, I didn't use different 
> one by accident. We want to make sure we won't use NULL from 
> tcp_write_queue_head() while the pre 08ebd1721ab8fd3 kernels was 
> interested mainly whether the first loop should run or not (and of course 
> ends up avoid the null deref too but it's more optimization like 
> thing in there, ie., if there's no lost packets no work to-do). The deref 
> could have been fixed by moving TCP_SKB_CB(skb)->sacked a bit later but 
> that would again make us depend on the side-effect of the send_head check 
> (in the case of packets_out being zero and wq empty) which is something I 
> don't like too much.
> 

Thanks Ilpo.

Do you know in what exact circumstance the bug triggers ?

It's hard to believe thousand of machines on the Internet never hit
it :(

Maybe another problem in congestion control ?



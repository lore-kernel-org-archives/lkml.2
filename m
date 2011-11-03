Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1KCAP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:15:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab1KCAPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:15:53 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=bCiEhsN2Qc0T3_-HhdEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320279351.4793.60.camel@gandalf.stny.rr.com>
Subject: Re: Linux 3.1-rc9
From: Steven Rostedt <rostedt@goodmis.org>
To: Simon Kirby <sim@hostway.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Network Development <netdev@vger.kernel.org>
Date: Wed, 02 Nov 2011 20:15:51 -0400
In-Reply-To: <20111103000941.GJ5971@hostway.ca>
References: <alpine.LFD.2.02.1110172237030.3240@ionos>
	 <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins>
	 <20111018182046.GF1309@hostway.ca>
	 <alpine.LFD.2.02.1110182146440.3240@ionos>
	 <20111024190203.GA24410@hostway.ca> <20111025202049.GB25043@hostway.ca>
	 <20111031173246.GA10614@hostway.ca>
	 <20111102221023.GA27457@home.goodmis.org>
	 <20111102230009.GB27457@home.goodmis.org>
	 <20111103000941.GJ5971@hostway.ca>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 17:09 -0700, Simon Kirby wrote:
>  
> [   49.032008] other info that might help us debug this:
> [   49.032008] 
> [   49.032008]  Possible unsafe locking scenario:
> [   49.032008] 
> [   49.032008]        CPU0                    CPU1
> [   49.032008]        ----                    ----
> [   49.032008]   lock(slock-AF_INET);
> [   49.039565]                                lock(slock-AF_INET/1);
> [   49.039565]                                lock(slock-AF_INET);
> [   49.039565]   lock(slock-AF_INET/1);
> [   49.039565] 
> [   49.039565]  *** DEADLOCK ***
> [   49.039565] 

> Did that help? I'm not sure if that's what you wanted to see...


Yes, this looks much better than what you previously showed. The added
"/1" makes a world of difference.

Thanks!

I'll add your "Tested-by". Seems rather strange as we didn't fix the bug
you are chasing, but instead fixed the output of what the bug
produced ;)

-- Steve



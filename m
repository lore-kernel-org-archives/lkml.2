Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907Ab2DKAhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:37:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2DKAhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:37:22 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=FZWJNzLSLkjWNZaiuTYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334104638.23924.233.camel@gandalf.stny.rr.com>
Subject: Re: CPU Hotplug rework
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Tue, 10 Apr 2012 20:37:18 -0400
In-Reply-To: <20120411002836.GM2428@linux.vnet.ibm.com>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <4F67474A.20707@linux.vnet.ibm.com>
	 <20120405173918.GC8194@linux.vnet.ibm.com>
	 <4F7F4977.4000302@linux.vnet.ibm.com>
	 <1334102999.23924.232.camel@gandalf.stny.rr.com>
	 <20120411002836.GM2428@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 17:28 -0700, Paul E. McKenney wrote:

> > Just to throw out the stupid silly approach.
> > 
> > What about creating a "__register_cpu_notifier()" that just does:
> > 
> > int __ref __register_cpu_notifier(struct notifier_block *nb)
> > {
> > 	return raw_notifier_chain_register(&cpu_chain, nb);
> > }
> > 
> > Also making cpu_maps_update_begin/done() global (and probably rename
> > them).

I just noticed that the cpu_maps_update_begin/done() are already global.

> > 
> > and then in the above code do:
> > 
> > 	cpu_maps_update_begin();
> > 	__register_cpu_notifier(nb);
> > 	do_setup();
> > 	cpu_maps_update_done();
> > 
> > 
> > Just saying,
> 
> That does have some attractive properties, now that you mention it.  ;-)

Which property? Stupid or Silly ;-)


-- Steve



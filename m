Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab2CTL2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:28:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:58794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496Ab2CTL2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:28:30 -0400
Message-ID: <1332242881.18960.409.camel@twins>
Subject: Re: CPU Hotplug rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-alpha@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Date: Tue, 20 Mar 2012 12:28:01 +0100
In-Reply-To: <4F67474A.20707@linux.vnet.ibm.com>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <4F67474A.20707@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 20:18 +0530, Srivatsa S. Bhat wrote:
> 
> If there is anything I missed out, please feel free to add them here.
> And suggestions are of course, always welcome :-)
> 
OK, so I haven't fully read your list, but looking through the code
today I found that alpha and blackfin call CPU_STARTING after
set_cpu_online(, true), whereas all the other archs call CPU_STARTING
before.

Aside from that probably wanting to get fixed (not sure it actually
breaks anything atm), this is another reason most of that wants to be
generic code.

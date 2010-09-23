Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0IWQwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:52:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab0IWQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:52:15 -0400
X-Authority-Analysis: v=1.1 cv=DXcwXsiCy0m6dtfuzmckRBGBU5A53VFijNRGSYZIu9o= c=1 sm=0 a=hbyrWHrROfsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3LGg-PHXSS5XLkOEo50A:9 a=Cr5MNXT2GmUuyblwEZq8UQ2amy8A:4 a=PUjeQqilurYA:10 a=hjLVYPQsdo_nVFXg:21 a=4fxi8Y86B8mCjClW:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 03/11] jump label: Base patch for jump label
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20100923153902.GD2825@redhat.com>
References: <20100923034910.867858597@goodmis.org>
	 <20100923035608.228041459@goodmis.org> <20100923143758.GA4022@Krystal>
	 <20100923153902.GD2825@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Sep 2010 12:52:11 -0400
Message-ID: <1285260731.26872.1436.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 11:39 -0400, Jason Baron wrote:
> On Thu, Sep 23, 2010 at 10:37:58AM -0400, Mathieu Desnoyers wrote:

> I was thinking about the rcu_read_lock/synchronize_rcu() for this race.
> We can hold the rcu_read_lock() across the is_module_text_address()
> check in the jump label code, and then we can do in module.c:
> 
> mod->module_init = NULL;
> synchronize_rcu();
> module_free(mod, mod->module_init);

Um, isn't that last call the same as:

	module_free(mod, NULL); ?

I'll spend some time looking at this too.

-- Steve

> .
> .
> .
> 
> or we could push the rcu_read_lock() further down into
> is_module_address()?
> 
> thanks,
> 
> -Jason
> 



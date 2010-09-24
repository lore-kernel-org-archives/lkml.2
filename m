Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0IXNyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:54:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab0IXNyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:54:24 -0400
X-Authority-Analysis: v=1.1 cv=agRZR3qYsXxPmcdSKOooeMKP57MfUQWeQiGdAPNrIgU= c=1 sm=0 a=hbyrWHrROfsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=uJqY3IyBs_GDX2CaHB8A:9 a=bnYmu09FF488TyavyS8A:7 a=2PKLi-65Pi44Vro_7J8LCDDT1QwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <20100923184006.GE2825@redhat.com>
References: <20100923034910.867858597@goodmis.org>
	 <20100923035608.228041459@goodmis.org> <20100923143758.GA4022@Krystal>
	 <20100923153902.GD2825@redhat.com> <20100923154852.GA12648@Krystal>
	 <20100923184006.GE2825@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 24 Sep 2010 09:54:20 -0400
Message-ID: <1285336460.31083.10.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 14:40 -0400, Jason Baron wrote:

> I agree that we this synchronization for the module __init section.
> 
> However, I believe we are ok for module removal case. free_module() is
> called *after* blocking_notifier_call_chain() call. The
> blocking_notifier_call_chain() is going to call back into the jump label
> code, grab the jump_label_mutex and remove the reference to the module that
> is about to freed. Thus, the jump label code can no longer reference it.
> 
> So I think the following patch is all that is required here (lightly
> tested).
> 
> Steve, I'll re-post as a separate patch, if we agree on this fix.

Ug, I'm struggling to get ready for my Tokyo trip. I'll try to look at
it on the flight. But I still need to write my presentation :-)

I may have a response back till Monday or Tuesday.

-- Steve



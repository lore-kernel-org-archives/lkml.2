Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0IGK5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:57:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48682 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab0IGK50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:57:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: disabling group leader perf_event
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikQk0S-mR2Ow2NgdzqAMB0DD05Vd1Th99gNRy8h@mail.gmail.com>
References: <20100906154737.GA4332@elte.hu> <AANLkTikQk0S-mR2Ow2NgdzqAMB0DD05Vd1Th99gNRy8h@mail.gmail.com>
Message-Id: <20100907141319.C90D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  7 Sep 2010 19:57:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As for the intermediate form, you might want to take a look at Dalvik:
> 
> http://www.netmite.com/android/mydroid/dalvik/docs/dalvik-bytecode.html
> 
> and probably ParrotVM bytecode too. The thing to avoid is stack-based
> instructions like in Java bytecode because although it's easy to write
> interpreters for them, it makes JIT'ing harder (which needs to convert
> stack-based representation to register-based) and probably doesn't
> lend itself well to stack-constrained kernel code.

(offtopic)

Afaik, NetBSD plan to include lua interpreter in kernel. it is optimized embedded environment.


(more offtopic)

in kernel interpreter is needed some concern. 1) restricted stack size (typical userland VM
often use >100K stack size)  2) restrected memory allocation, especially high order allocation 
often fail. 3) GC often makes unacceptable large lag especially on UP kernel. etc etc
So, We can't apply rich interpreter (e.g. Dalvik, Parrrot) so easily. I think. personally I prefer
minimum component.

Thanks.




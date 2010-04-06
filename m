Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0DFSQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:16:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0DFSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:16:01 -0400
X-Authority-Analysis: v=1.1 cv=1G73JCAd+9Vhhx30tk0+Sc/rngIYAy4Ia+6Xn7XSY0k= c=1 sm=0 a=GUZThVASlngA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=J1Y8HTJGAAAA:8 a=9TnVHUmldIimhBHmhvkA:9 a=N6hLY2TT0r0PZi0rdmUA:7 a=ajunYQIp6PR5VAjCdxD4oqP5PHIA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=4N9Db7Z2_RYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Miller <davem@davemloft.net>
Cc: srostedt@redhat.com, fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       a.p.zijlstra@chello.nl, paulus@samba.org
In-Reply-To: <20100406.104635.210218044.davem@davemloft.net>
References: <20100405194055.GA5265@nowhere>
	 <20100405.191555.184824968.davem@davemloft.net>
	 <1270561264.2738.8.camel@localhost.localdomain>
	 <20100406.104635.210218044.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 06 Apr 2010 14:15:58 -0400
Message-ID: <1270577758.19685.15557.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 10:46 -0700, David Miller wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> Date: Tue, 06 Apr 2010 09:41:04 -0400
> 
> > It's best to send to my rostedt@goodmis.org account, just like it is
> > best to send to your davem@davemloft.net ;-)
> 
> Ok then you should, like me, use it in your commits :-)
> 

My SoB is rostedt@goodmis.org, my commits are srostedt@redhat.com just
because I want to give credit to the one that pays me for making those
commits ;-)


> > What about removing the logic from the ring buffer and moving it to the
> > TRACE_EVENT() macros as I suggested above?
> 
> No, that makes no sense, just align the data types properly
> instead of making every single access site pay the price.

OK

> 
> Just fix the CPP test to handle 32-bit platforms with slow
> mis-alignment handling, everything else seems to be working properly
> after I fixed the NMI issues on sparc64.

A little more work will need to be done since on 32bit, the page headers
are 12 bytes, not 16, so we start off without being aligned 8bytes. But
that too is fixable.

-- Steve



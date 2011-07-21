Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1GUQvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:51:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:51734 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1GUQvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:51:53 -0400
Subject: Re: sched: fix/optimise some issues
From: Peter Zijlstra <peterz@infradead.org>
To: Stephan =?ISO-8859-1?Q?B=E4rwolf?= 
	<stephan.baerwolf@tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4E28557A.7040704@tu-ilmenau.de>
References: <4E26DB41.9070002@tu-ilmenau.de>
	 <1311260895.29152.153.camel@twins>  <4E28557A.7040704@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 18:51:48 +0200
Message-ID: <1311267108.29152.178.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 18:36 +0200, Stephan Bärwolf wrote:
> I also remember weak Linus had sth. against "priority inheritance"
> (don't ask me what or why - I don't know),
> but it would be an honour to me working with you guys to implement
> this feature in future kernels. 

Look at kernel/rt_mutex.c, it as a complete tradition Priority
Inheritance implementation :-)

The trouble is that it only works for SCHED_FIFO/RR.

Now you can extend PI to cover weighted fair queueing, or implement the
much simpler proxy execution policy which generalizes to pretty much any
scheduling algorithm, see for example the paper: "Timeslice donation in
component-based systems" in:

http://www.artist-embedded.org/docs/Events/2010/OSPERT/OSPERT2010-Proceedings.pdf

Extending that to SMP is the 'interesting' bit..

However that will not solve the true idle thing since some
synchronization primitives we have are fundamentally incompatible with
any form of PI (including the various ceiling protocols) :-/, see for
example the traditional semaphore and completions. 


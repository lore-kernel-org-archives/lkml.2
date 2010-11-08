Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0KHUlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:41:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46362 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0KHUlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:41:20 -0500
Subject: Re: Q: perf_event && event->owner
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101108201108.GA6777@nowhere>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145754.GB3434@redhat.com>  <20101108201108.GA6777@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 08 Nov 2010 21:41:12 +0100
Message-ID: <1289248872.2191.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 21:11 +0100, Frederic Weisbecker wrote:
> Perhaps the real owner should be the task on which we attach our
> breakpoint.

No the point of event->owner is to point to the task that creates the
event, not the task we possibly attach it to (that should be reachable
through event->ctx->task).

As to removing event->owner as Oleg suggests, its a published ABI and
there might be people using it.

The use-case is a monitor thread wanting to stop all monitoring it
initiated, for example because its wants to synchronize various counters
attached to different tasks etc..



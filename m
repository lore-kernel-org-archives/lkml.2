Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0CZHsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 03:48:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab0CZHsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 03:48:42 -0400
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1269586358.12097.117.camel@laptop>
References: <1269570142-13965-1-git-send-regression-fweisbec@gmail.com>
	 <1269586358.12097.117.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 08:48:34 +0100
Message-ID: <1269589714.12097.122.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 07:52 +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-26 at 03:22 +0100, Frederic Weisbecker wrote:
> > We can't use irqsafe per cpu counters for that as
> > these stats might be also written from NMI path, and irqsafe per
> > cpu counters are not NMI safe, but local_t operations are.
> > 
> lockdep shouldn't do NMI, nmi_enter() has an explicit lockdep_off().

Also, more importantly, you simply should never use locks in NMI context
to begin with ;-)


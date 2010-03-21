Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0CUQ3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 12:29:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56470 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0CUQ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 12:29:13 -0400
Date: Sun, 21 Mar 2010 17:29:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
In-Reply-To: <m1iq8p23af.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.64.1003211718270.12371@ask.diku.dk>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
 <1267697339-5491-7-git-send-email-yinghai@kernel.org>
 <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org>
 <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk> <m1eije71et.fsf@fess.ebiederm.org>
 <Pine.LNX.4.64.1003211153470.7805@ask.diku.dk> <m1iq8p23af.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a function set_irq_chained_handler that takes a function, 
handler, as its second argument.  It seems that handler is always then 
called with and irq as the first argument and the associated desc as the 
second argument.  If this is the case, one could drop the irq argument and 
only use desc.  A lot of calls of the form

desc->chip->...(irq_to_desc(irq))

could then become

desc->chip->...(desc)

julia

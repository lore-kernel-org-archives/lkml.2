Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0CZGwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:52:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab0CZGwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:52:42 -0400
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1269570142-13965-1-git-send-regression-fweisbec@gmail.com>
References: <1269570142-13965-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 07:52:38 +0100
Message-ID: <1269586358.12097.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 03:22 +0100, Frederic Weisbecker wrote:
> We can't use irqsafe per cpu counters for that as
> these stats might be also written from NMI path, and irqsafe per
> cpu counters are not NMI safe, but local_t operations are.
> 
lockdep shouldn't do NMI, nmi_enter() has an explicit lockdep_off().


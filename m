Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab1AMUYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:24:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33664
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629Ab1AMUYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:24:49 -0500
Date: Thu, 13 Jan 2011 12:25:22 -0800 (PST)
Message-Id: <20110113.122522.107108292.davem@davemloft.net>
To: peterz@infradead.org
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc boot failure due to perf init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294916129.19601.88.camel@laptop>
References: <20110107203119.GA30408@merkur.ravnborg.org>
	<20110109.153745.35032992.davem@davemloft.net>
	<1294916129.19601.88.camel@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 13 Jan 2011 11:55:28 +0100

> I just realized, doesn't this make bootability depend on link order?
> Since both the pmu init and its dependencies are now early_initcall()
> how do we guarantee pcr_arch_init() and cpu_type_probe() are in fact
> called _before_ init_hw_perf_events()?

Yes, it does, and I made sure the ordering in the sparc Makefile
satisfied the constraints.

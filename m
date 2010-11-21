Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0KUMJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 07:09:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52734 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab0KUMJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 07:09:39 -0500
Message-ID: <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
In-Reply-To: <1290340907.2245.125.camel@localhost>
References: <1290340907.2245.125.camel@localhost>
Date: Sun, 21 Nov 2010 13:09:35 +0100
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore
 events
From: "Andi Kleen" <andi@firstfloor.org>
To: "Lin Ming" <ming.m.lin@intel.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Stephane Eranian" <eranian@google.com>,
        "Andi Kleen" <andi@firstfloor.org>,
        "lkml" <linux-kernel@vger.kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Arjan van de Ven" <arjan@infradead.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>              samples  pcnt function               DSO
>              _______ _____ ______________________
> ____________________________________
>
>                 8.00 18.6% kallsyms_expand_symbol [kernel.kallsyms]

Reporting a symbol for an uncore event seems highly misleading.
After all the uncore counter has no idea for which core the event was,
so there isn't really any instruction pointer to report.
The event could be event caused by a PCI device or similar.

For per function monitoring of uncore events one has to use
OFFCORE_RESPONSE, like I implemented recently.

I would suggest to not report any symbol names for uncore events.
Doing so just will confuse users.

In fact I suspect uncore events are only really useful
with "stat", but not with "top", or if they are used in top
then the symbol reporting should be disabled.

-Andi



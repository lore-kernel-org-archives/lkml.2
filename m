Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0KUQwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:52:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41279 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0KUQwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:52:18 -0500
Message-ID: <3889bf3ab66bbb35ea239b63d95cc4c4.squirrel@www.firstfloor.org>
In-Reply-To: <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
References: <1290340907.2245.125.camel@localhost>
    <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
    <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
Date: Sun, 21 Nov 2010 17:52:14 +0100
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore
 events
From: "Andi Kleen" <andi@firstfloor.org>
To: "Stephane Eranian" <eranian@google.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Lin Ming" <ming.m.lin@intel.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Ingo Molnar" <mingo@elte.hu>, "lkml" <linux-kernel@vger.kernel.org>,
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


>>
>> In fact I suspect uncore events are only really useful
>> with "stat", but not with "top", or if they are used in top
>> then the symbol reporting should be disabled.
>>
> I agree, uncore should only be used for counting on a
> per-cpu basis. You can leave the perf tool as is, but

I think you mean per socket base, right? per cpu (= cpu core thread)
doesn't make sense for the uncore either.

Per socket would need a new command line mode. The new mode should
never report any symbols or processes, just events per socket.

-Andi


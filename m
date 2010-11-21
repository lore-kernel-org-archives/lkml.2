Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab0KUMWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 07:22:09 -0500
Received: from smtp-out.google.com ([74.125.121.35]:46361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0KUMWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 07:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ewrZnNODwU6FTpe2qoR7Y7Q6tOjcq9SNGjSiZS14qdIIn9Fh94o+jnwa43yqNr5Bmp
         tmvi9mBhYaZLFoKRevaA==
MIME-Version: 1.0
In-Reply-To: <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
References: <1290340907.2245.125.camel@localhost>
	<340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
Date: Sun, 21 Nov 2010 13:22:03 +0100
Message-ID: <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore events
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 1:09 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
>>
>>              samples  pcnt function               DSO
>>              _______ _____ ______________________
>> ____________________________________
>>
>>                 8.00 18.6% kallsyms_expand_symbol [kernel.kallsyms]
>
> Reporting a symbol for an uncore event seems highly misleading.
> After all the uncore counter has no idea for which core the event was,
> so there isn't really any instruction pointer to report.
> The event could be event caused by a PCI device or similar.
>
> For per function monitoring of uncore events one has to use
> OFFCORE_RESPONSE, like I implemented recently.
>
> I would suggest to not report any symbol names for uncore events.
> Doing so just will confuse users.
>
> In fact I suspect uncore events are only really useful
> with "stat", but not with "top", or if they are used in top
> then the symbol reporting should be disabled.
>
I agree, uncore should only be used for counting on a
per-cpu basis. You can leave the perf tool as is, but
that opens up the risk of misinterpretation by many users,
or you restrict this in the tool directly which is the better
solution in my mind.

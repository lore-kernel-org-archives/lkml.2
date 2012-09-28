Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2I1LfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:35:15 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41460 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab2I1LfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:35:12 -0400
MIME-Version: 1.0
In-Reply-To: <1348822920.3292.60.camel@twins>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	<1348806696-31170-5-git-send-email-andi@firstfloor.org>
	<1348822920.3292.60.camel@twins>
Date: Fri, 28 Sep 2012 13:35:12 +0200
Message-ID: <CABPqkBSpdJ2GaGC2zQYFC6Jre-fnZBiXbX3VBfwA4GCQf7+Lww@mail.gmail.com>
Subject: Re: [PATCH 04/31] perf, core: Add generic intx/intx_checkpointed
 counter modifiers
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:02 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
>> +                               intx           :  1, /* count inside transaction */
>> +                               intx_checkpointed :  1, /* checkpointed in transaction */
>
> I really hate those names.. what are they called in transactional memory
> literature?
>
> Also do we really need this? Using the event format stuff we could
> equally well do:
>
> {cpu/cycles/, cpu/cycles,intx/, cpu/cycles,intx_checkpointed/}
>
> No need to push those bits through perf_event_attr::flags when you can
> stuff then through perf_event_attr::config, esp. for very hardware
> specific features.

Make sense to promote them if they exist on other arch. If not, then
for now, they
should be in sysfs. Doing this does not preclude future promotions if
there is more
architectures supporting the exact same meaning.

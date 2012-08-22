Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab2HVSmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:42:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55688 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2HVSm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:42:28 -0400
Message-ID: <5035280E.2060100@gmail.com>
Date: Wed, 22 Aug 2012 12:42:22 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Luigi Semenzato <semenzato@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] perf: do not flush maps on COMM for perf report
References: <1345585940-6497-1-git-send-email-semenzato@chromium.org> <20120822072822.GA11042@gmail.com> <CAA25o9RJOre2mw4z7Mh94iRKcHVdby9RjLfP91far16me8_94Q@mail.gmail.com> <20120822162958.GA13623@infradead.org> <50350F2D.6030408@gmail.com> <20120822181653.GB13623@infradead.org>
In-Reply-To: <20120822181653.GB13623@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/12 12:16 PM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 22, 2012 at 10:56:13AM -0600, David Ahern escreveu:
>> On 8/22/12 10:29 AM, Arnaldo Carvalho de Melo wrote:
>>> Adding the EXEC event, ditto. And I agree that while adding it we want
>>> to do 1/2 as pre-requisite.
>>
>> maps should not be flushed on a COMM event, so that was a mistake.
>> Given that what new information does an EXEC event provide? Same
>> process id. A COMM event is generated on an exec, so the name change
>> happens. Mappings are dropped prior to that - and there is no unmap
>> event. That seems to be a missing piece. Maps are added which is
>> handled by MMAP events. After that why is an exec event relevant?
>
> Please read the original discussion about it:
>
> https://lkml.org/lkml/2012/2/13/545

I do recall that discussion (and re-read just now). If maps are not 
flushed on a rename (and they should not be), then I still do not 
understand what information is conveyed by an exec event? It's not a new 
process or new map and the name change is already handled by a comm event.

David


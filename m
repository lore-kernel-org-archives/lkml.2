Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2GXR3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:29:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63165 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab2GXR27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:28:59 -0400
Message-ID: <500EDB50.3070704@gmail.com>
Date: Tue, 24 Jul 2012 11:28:48 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-9-git-send-email-dsahern@gmail.com> <20120723181358.GC6717@infradead.org> <500EAF23.8060909@gmail.com> <20120724161507.GG3732@erda.amd.com>
In-Reply-To: <20120724161507.GG3732@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/12 10:15 AM, Robert Richter wrote:
> David,
>
> On 24.07.12 08:20:19, David Ahern wrote:
>> On 7/23/12 12:13 PM, Arnaldo Carvalho de Melo wrote:
>>> Em Fri, Jul 20, 2012 at 05:25:53PM -0600, David Ahern escreveu:
>>>> PEBS cannot be used with guest mode. If user adds :p modifier set
>>>> exclude_guest as well.
>>>
>>> Is this something Intel specific? Or can someone think of an arch where
>>> this limitation wouldn't exist?
>>
>> Good point. So far precise_ip is used by arch/x86 only. I don't have an
>> AMD based server so I don't know if there is a conflict between
>> virtualization and IBS. Added Robert for advice.
>
> thanks for this hint.
>
> On AMD cpus precise_ip maps to IBS, which does not support hardware
> options as perfctrs do. Thus, following attr flags are not supported:
>
>   exclude_user, exclude_kernel, exclude_host, exclude_guest
>
> Counting in guest mode is possible with IBS, but not the exclusion of
> a certain mode. If precise_ip counting is enabled on AMD we may not
> set the exclude_guest flag.

Ok, so with AMD precise_ip requires exclude_guest to be unset; for Intel 
we need it set.

So then we look at vendor_id in /proc/cpuinfo?

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2EHB6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 21:58:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56176 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab2EHB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 21:58:41 -0400
X-AuditID: 9c93016f-b7c79ae0000006b3-30-4fa87dcd4086
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] perf tools: Introduce perf_target__strerror()
References: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
	<1336367344-28071-6-git-send-email-namhyung.kim@lge.com>
	<20120507172946.GC2485@infradead.org> <4FA809AD.7060209@gmail.com>
Date: Tue, 08 May 2012 10:57:12 +0900
In-Reply-To: <4FA809AD.7060209@gmail.com> (David Ahern's message of "Mon, 07
	May 2012 11:43:09 -0600")
Message-ID: <87r4uvcu4n.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 07 May 2012 11:43:09 -0600, David Ahern wrote:
> On 5/7/12 11:29 AM, Arnaldo Carvalho de Melo wrote:
>> Em Mon, May 07, 2012 at 02:09:02PM +0900, Namhyung Kim escreveu:
>>> The perf_target__strerror() sets @buf to a string that
>>> describes the (perf_target-specific) error condition
>>> that is passed via @errnum.
>>>
>>> This is similar to strerror_r() and does same thing if
>>> @errnum has a standard errno value.
>>
>> This has a problem: why should I be warned when I do, as root:
>>
>> # perf top -u acme
>>
>> It warns me that "UID switch overriding SYSTEM", yeah, right that is
>> what I asked, no need to tell me that :-)
>>
>> So what is missing in this case is that top starts with system_wide set,
>> not from the command line.
>>
> Seems like we should avoid the propagation of the errnos beyond the
> depths of the library part. For perf-top why not default to nothing
> set and if the user does not request one, set system wide. i.e,
> following Patch 6 in this set do:
>
> if (perf_target__none(&top.target)
>     top.target.system_wide = true;
>

Thanks for catching this (and sorry for not testing thoroughly).

Yes, this would make more sense if it goes to the patch 1. Now I see
that Arnaldo fixed it on patch 1 but forgot to update on patch 6 :).

Thanks,
Namhyung


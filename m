Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829Ab2EWArS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:47:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51842 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab2EWArP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:47:15 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-28-4fbc338f8694
From: Namhyung Kim <namhyung.kim@lge.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	<1337081295-10303-5-git-send-email-eranian@google.com>
	<4FB32032.3000509@gmail.com>
	<CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
	<4FB67DE5.8050000@gmail.com> <20120518171911.GH2636@infradead.org>
	<1337708035.9698.44.camel@twins>
	<CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
Date: Wed, 23 May 2012 09:45:12 +0900
In-Reply-To: <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
	(Stephane Eranian's message of "Tue, 22 May 2012 19:51:15 +0200")
Message-ID: <87obpf209z.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 22 May 2012 19:51:15 +0200, Stephane Eranian wrote:
> On Tue, May 22, 2012 at 7:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, 2012-05-18 at 14:19 -0300, Arnaldo Carvalho de Melo wrote:
>>
>>> PeterZ was the one objecting to adding more userspace only events,
>>
>> Ah, yes I was ;-)
>>
>> So uhm the argument was something like perf_event_type is a kernel enum
>> and userspace stealing space there is going to get us into trouble
>> eventually since userspace doesn't register its types in our enum.
>>
> Yes, I did not start this but I understand why it was done that way.
>
> The problem is that the headers as they are written to the file need
> seeking in the file to update the offset table. That is NOT possible when
> you operate in pipe mode. As such you need to inject the header infos
> very much like kernel PERF_RECORD_*. That is also why you have
> perf inject -b. Buildids are added at the end of the run in file mode,
> and that's another seek to the offset table if I recall correctly.
>

IIUC, to add build-ids we should check all dso's whether hits or not,
but it's not same as the case of meta-data since we can know it before
processing. Am I missing something?

Thanks,
Namhyung

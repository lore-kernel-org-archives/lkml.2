Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967257Ab2EPDzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 23:55:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989Ab2EPDzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 23:55:40 -0400
Message-ID: <4FB32538.1070004@gmail.com>
Date: Tue, 15 May 2012 21:55:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com
Subject: Re: [PATCH v2 5/5] perf: make perf buildid-list work better with
 pipe mode
References: <1337081295-10303-1-git-send-email-eranian@google.com> <1337081295-10303-6-git-send-email-eranian@google.com>
In-Reply-To: <1337081295-10303-6-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/12 5:28 AM, Stephane Eranian wrote:
> In order for perf buildid-list to work with pipe-mode files,
> it needs to process buildids and event attr structs.
>
> $ perf record -o - noploop 2 | ./perf inject -b | perf buildid-list -i - -H
> noploop for 2 seconds
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.084 MB - (~3678 samples) ]
> 0000000000000000000000000000000000000000 [kernel.kallsyms]
> 3a0d0629efe74a8da3eeba372cdbd74ad9b8f5d5 /usr/local/bin/noploop
>
> The reason [kernel.kallsyms] shows a 0 build-id comes from the
> way buildids are injected in the stream. The buildid for the kernel
> is provided by a BUILD_ID record. The [kernel.kallsyms] is provided
> by a MMAP record. There is no clean and obvious way to link the two,
> unfortunately. In regular mode, the kernel buildid is generated from
> reading the ELF image or kallsyms and perf knows to associate
> [kernel.kallsyms] to it. Later on, when perf processes the
> [kernel.kallsyms] MMAP record, it will already have a dso for it.
>
> So for now, make sure perf buildid-list shows the buildids for
> everything but the kernel image.
>
> Signed-off-by: Stephane Eranian<eranian@google.com>
> ---
>   tools/perf/builtin-buildid-list.c |    6 +++++-
>   tools/perf/util/build-id.c        |    2 ++
>   2 files changed, 7 insertions(+), 1 deletions(-)

Reviewed-and-tested-by: David Ahern <dsahern@gmail.com>

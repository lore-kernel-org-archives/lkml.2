Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2HCR2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:28:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32832 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2HCR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <501BED28.30208@gmail.com>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
	<1344002470-5965-9-git-send-email-acme@infradead.org>
	<501BED28.30208@gmail.com>
Date: Fri, 3 Aug 2012 19:28:34 +0200
Message-ID: <CABPqkBS1O+OZ9STAz+C4DCqY8_1kYNwF-TMVm-Xc7D9AG0vC3Q@mail.gmail.com>
Subject: Re: [PATCH 08/18] perf evlist: Introduce perf_evlist__parse_sample
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 5:24 PM, David Ahern <dsahern@gmail.com> wrote:
> On 8/3/12 8:01 AM, Arnaldo Carvalho de Melo wrote:
>>
>> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>>
>> That is a more compact form of perf_session__parse_sample and to support
>> multiple evlists per perf_session is the way to go anyway.
>
>
> So then all events in an evlist will have the same sample type? If you want
> different sample types (at some point in the future) you will have to create
> separate evlists?
>
Yes, you do want separate sample_type, otherwise you may be wasting a lot
of buffer space and thus disk space for data you don't want. This is especially
true once you start using the branch stack feature. But for that the
kernel buffer
format has to be extended. I have a patch that does that. Just haven't
had the time
to finish the perf support for it.

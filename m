Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2BWUsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:48:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38524 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab2BWUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:48:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.112.85.233 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <20120223181132.GB3571@infradead.org>
References: <1328826068-11713-1-git-send-email-eranian@google.com>
	<1328826068-11713-14-git-send-email-eranian@google.com>
	<20120222111501.GA23068@elte.hu>
	<CABPqkBQz0G6DQfAfzD2=1mCDvmVsaZhFjW0qEh4y+rNxtbLC4Q@mail.gmail.com>
	<20120223095922.GC24310@elte.hu>
	<CABPqkBT39C6zaKWGoHrRjqWE2P433NF-gYCYoa=JkJnGzMVjMQ@mail.gmail.com>
	<20120223181132.GB3571@infradead.org>
Date: Thu, 23 Feb 2012 21:48:38 +0100
Message-ID: <CABPqkBTufRUjVN_0v3h7RfcFmmO4h4N04wb0ypP5jq22UbYV4w@mail.gmail.com>
Subject: Re: [PATCH v6 13/18] perf: add support for taken branch sampling to
 perf report
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com,
        dsahern@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 7:11 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Thu, Feb 23, 2012 at 05:53:53PM +0100, Stephane Eranian escreveu:
>> Ok, so I looked at that today. Adding the feature bit is trivial.
>> But what's not easy is to get to the feature bit in perf report
>> by the time we need it. Very quickly after parsing the options,
>> we setup a bunch of things such as browser mode, sorting
>> order based on the -b option. But to get to the feature bit, we
>> would need to wait until after the session is created in
>> __cmd_report() which is way later.
>>
>> So we either hoist perf_session__new() very early, i.e., as soon
>> as we have the filename or we write yet another parse_header()
>> function just to get to the feature bits. I would rather choose the
>> first option. But none is really pretty...
>>
>> Arnaldo, any better idea?
>
> Humm, lemme see...
>
>
> By the time we need it is when we do setup_sorting, right? Perhaps we
> can delay that till after we do perf_session__new and thus have read the
> headers...
>
Well, there is also the UI setup (use_stdio setup_browser and the likes).
Then, yes, it's sorting.

> /me looks at the code.
>
> - Arnaldo

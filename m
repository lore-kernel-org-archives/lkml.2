Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1IWJEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:04:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47563 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1IWJEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:04:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=UGZW28QS/C9lVr16hb8bzv0la8Qeh71MeSFcm2OXk0m3GvlZe0arQGpw+73Q73Cn/
	daab+o5IUip4xrP767aPg==
MIME-Version: 1.0
In-Reply-To: <CAOJsxLE1L1ffZmuF+2+vYZMTXyvq00pOcP1xvGJuW0TqxQskrA@mail.gmail.com>
References: <20110922123128.GA9761@quad>
	<CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com>
	<CABPqkBQSBKS+bnLhStzV4PTrE+Qrb1XyeR5FEyn4d+NFZrhuOQ@mail.gmail.com>
	<CAOJsxLE1L1ffZmuF+2+vYZMTXyvq00pOcP1xvGJuW0TqxQskrA@mail.gmail.com>
Date: Fri, 23 Sep 2011 11:04:05 +0200
Message-ID: <CABPqkBSpqNWJVhRh4bKRK5PGcCdZhzsJzyeQ53Mh4_7fVUm+wg@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
From: Stephane Eranian <eranian@google.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, robert.richter@amd.com,
        ak@linux.intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 10:03 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Stephane!
>
> On Fri, Sep 23, 2011 at 10:31 AM, Stephane Eranian <eranian@google.com> wrote:
>>> So how important is this information? The output is going to be somewhat
>>> awkward for very large CPU counts... :-)
>>>
>> It is useful to determine how CPUs share caches for instance.
>> It can get large but large, but the meta-data header is not printed by
>> default, you need to request it with the -I option.
>
> Well, sure but it blocks rest of the interesting information too. It seems to me
> that the CPU information could be truncated to some sane limit by default and
> introduce a command line option for users that really want to see all of it.
>
Ok, so here is a proposal:
- reorder the info so one liners appear first
- display the "truncated" info by default (no option)
- truncated: numa topo, cpu topo, stop after 4 cpus/nodes, print msg
to hint at -I option
- use -I to print the extended header info report

That way we do no introduce two options just for the header information.

How about that instead?

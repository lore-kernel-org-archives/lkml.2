Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab1LETYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:24:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57547 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1LETYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:24:07 -0500
MIME-Version: 1.0
In-Reply-To: <20111205132340.GH15738@erda.amd.com>
References: <20110930134040.GA5575@quad>
	<20111129182231.GZ15738@erda.amd.com>
	<CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
	<20111130150829.GA15738@erda.amd.com>
	<20111130164946.GA27163@infradead.org>
	<20111201150151.GA15110@somewhere.redhat.com>
	<20111201151520.GB15738@erda.amd.com>
	<CABPqkBQwQ1gzQEfAehiLRXrO196vovNeRjS9taiM7dfk7U9egQ@mail.gmail.com>
	<20111205132340.GH15738@erda.amd.com>
Date: Mon, 5 Dec 2011 11:24:05 -0800
Message-ID: <CABPqkBTBpMao99t407Oz1cKMAVDYEsFSLUe85DYeOzxzuhZ9hg@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v8)
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "acme@redhat.com" <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 5:23 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 01.12.11 09:53:10, Stephane Eranian wrote:
>> On Thu, Dec 1, 2011 at 7:15 AM, Robert Richter <robert.richter@amd.com> wrote:
>> > I am asking this because I want to change code in a way that treats
>> > all features the same, that is just to disable the feature bit on
>> > failure and then continue anyway.
>> >
>> You need to make sure that disabling the bit is enough to still get a consistent
>> file, i.e., want to undo the effect of writing the feature to the
>> file. In the case
>> of the meta-data features I added that was easy simply lseek() back to
>> the position
>> before the call. Would that be the case with TRACE_INFO?
>
> It should be. All features can be parsed independently. Offset and
> size of a feature's data block is stored in struct perf_file_section
> right after the data block of perf.data (see perf_session__write_
> header()). Thus, if a feature does not exist then other features can
> be processed anyway.
>
The one thing I realized last week, is that all that header information, incl.
the features bits do not seem to appear in the file perf.data file when you
use the perf record pipe mode. We need to fix that otherwise, if you
depend on information in those bits, it won't always be present. That's
a major issue.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1LARxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:53:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45990 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1LARxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:53:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111201151520.GB15738@erda.amd.com>
References: <20110930134040.GA5575@quad>
	<20111129182231.GZ15738@erda.amd.com>
	<CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
	<20111130150829.GA15738@erda.amd.com>
	<20111130164946.GA27163@infradead.org>
	<20111201150151.GA15110@somewhere.redhat.com>
	<20111201151520.GB15738@erda.amd.com>
Date: Thu, 1 Dec 2011 09:53:10 -0800
Message-ID: <CABPqkBQwQ1gzQEfAehiLRXrO196vovNeRjS9taiM7dfk7U9egQ@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 7:15 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 01.12.11 16:01:55, Frederic Weisbecker wrote:
>> On Wed, Nov 30, 2011 at 02:49:46PM -0200, acme@redhat.com wrote:
>> > Em Wed, Nov 30, 2011 at 04:08:29PM +0100, Robert Richter escreveu:
>> > > On 29.11.11 10:35:24, Stephane Eranian wrote:
>> > > >         sec_start = header->data_offset + header->data_size;
>> > > >         lseek(fd, sec_start + sec_size, SEEK_SET);
>> > > >
>> > > >         err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
>> > > >         if (err)
>> > > >                 goto out_free;
>> > > >
>> > > >         err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
>> > > >         if (err) {
>> > > >                 perf_header__clear_feat(header, HEADER_BUILD_ID);
>> > > >                 goto out_free;
>> > > >         }
>> >
>> > > > The 'clear_feat' is missing for TRACE_INFO, that's all. The question is:
>> > > > is case do_write_feat(trace_info) fails, is there still a way to parse the file
>> > > > correctly? If not, then perf should bail out, if yes, then we need to add the
>> > > > clear_feat(TRACE_INFO) in case of error.
>> >
>> > > The question is, if do_write_feat() fails for HEADER_TRACE_INFO or
>> > > HEADER_BUILD_ID then perf_header__adds_write() fails. A failure of any
>> > > other feature simple disables it by calling clear_feat(). I noticed
>> > > this asymmetry and wonder why?
>>
>> Not sure either. I must confess I didn't write that fixup part...
>
> I am asking this because I want to change code in a way that treats
> all features the same, that is just to disable the feature bit on
> failure and then continue anyway.
>
You need to make sure that disabling the bit is enough to still get a consistent
file, i.e., want to undo the effect of writing the feature to the
file. In the case
of the meta-data features I added that was easy simply lseek() back to
the position
before the call. Would that be the case with TRACE_INFO?

>>
>> > >
>> > > Also, is there a reason why HEADER_TRACE_INFO starts with bit 1 instead
>> > > of bit 0. Is bit 0 reserved for some reason?
>>
>> Looks like a mistake I made from the beginning. And we can't really fix that
>> without breaking all perf.data :)
>
> Ok, wasn't sure if the bit was used for other purposes, but seems to
> be always zero then.
>
> Thanks,
>
> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
>

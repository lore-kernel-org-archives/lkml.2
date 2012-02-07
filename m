Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2BGRmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:42:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35682 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab2BGRmp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:42:45 -0500
MIME-Version: 1.0
In-Reply-To: <4F315430.2090708@gmail.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
	<1328187288-24395-17-git-send-email-eranian@google.com>
	<4F3051E3.5050402@gmail.com>
	<CABPqkBSYwwQpfxj3daHF_YHfJWLUT-Pfd03_7_jtrBkO4kM2ag@mail.gmail.com>
	<4F315430.2090708@gmail.com>
Date: Tue, 7 Feb 2012 18:42:44 +0100
Message-ID: <CABPqkBR5j9wxNfSReXeLWmEdUHJmhnQUQ4W2mBqY-MatNSo0sA@mail.gmail.com>
Subject: Re: [PATCH v5 16/18] perf: enable reading of perf.data files from
 different ABI rev
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 5:41 PM, David Ahern <dsahern@gmail.com> wrote:
> On 02/07/2012 08:50 AM, Stephane Eranian wrote:
>>>> +     if (sz == 0) {
>>>> +             /* assume ABI0 */
>>>> +             sz =  PERF_ATTR_SIZE_VER0;
>>>
>>> Shouldn't this be a failure? ie., problem with the file (or the
>>> swapping) since size can't be 0
>>>
>> size can be zero. In which case, it means ABI0 version.
>> See kernel/event/core.c:perf_copy_attr().
>
> ok
>
>>
>>
>>> And then for the following why not restrict sz to known, expected sizes
>>> -- using the PERF_ATTR_SIZE_VER defines introduced in patch 15?
>>>
>> Well, the current code solves the problem once and for all. Old tools
>> can still read new files and vice-versa. If you think that's a problem I
>> can simply bail out if sz > our_sz.
>
> My sensitivity on this is when endianness is broken it is a nightmare to
> find. You end up lacing the code with printfs trying to find which size
> field is going off the charts making the parsing of the file fail - or
> worse the sizes are slightly off and you get non-sense out.
>
> New commands should be able to read old files; old commands reading new
> files is a bit of a stretch in that the code has to be future-proofed.
> It seems like a reasonable requirement for data files to be examined by
> a command of the same vintage or newer as the command that wrote the file.
>
Fine then, I can simply strip that part of the code and return an
error is sz > our_sz.
How about that?

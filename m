Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2BGQlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:41:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46827 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab2BGQla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:41:30 -0500
Message-ID: <4F315430.2090708@gmail.com>
Date: Tue, 07 Feb 2012 09:41:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com
Subject: Re: [PATCH v5 16/18] perf: enable reading of perf.data files from
 different ABI rev
References: <1328187288-24395-1-git-send-email-eranian@google.com> <1328187288-24395-17-git-send-email-eranian@google.com> <4F3051E3.5050402@gmail.com> <CABPqkBSYwwQpfxj3daHF_YHfJWLUT-Pfd03_7_jtrBkO4kM2ag@mail.gmail.com>
In-Reply-To: <CABPqkBSYwwQpfxj3daHF_YHfJWLUT-Pfd03_7_jtrBkO4kM2ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 08:50 AM, Stephane Eranian wrote:
>>> +     if (sz == 0) {
>>> +             /* assume ABI0 */
>>> +             sz =  PERF_ATTR_SIZE_VER0;
>>
>> Shouldn't this be a failure? ie., problem with the file (or the
>> swapping) since size can't be 0
>>
> size can be zero. In which case, it means ABI0 version.
> See kernel/event/core.c:perf_copy_attr().

ok

> 
> 
>> And then for the following why not restrict sz to known, expected sizes
>> -- using the PERF_ATTR_SIZE_VER defines introduced in patch 15?
>>
> Well, the current code solves the problem once and for all. Old tools
> can still read new files and vice-versa. If you think that's a problem I
> can simply bail out if sz > our_sz.

My sensitivity on this is when endianness is broken it is a nightmare to
find. You end up lacing the code with printfs trying to find which size
field is going off the charts making the parsing of the file fail - or
worse the sizes are slightly off and you get non-sense out.

New commands should be able to read old files; old commands reading new
files is a bit of a stretch in that the code has to be future-proofed.
It seems like a reasonable requirement for data files to be examined by
a command of the same vintage or newer as the command that wrote the file.

David

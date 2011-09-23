Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1IWNgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:36:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55760 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab1IWNgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:36:42 -0400
Message-ID: <4E7C8B67.9030708@gmail.com>
Date: Fri, 23 Sep 2011 07:36:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com, ak@linux.intel.com
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
References: <20110922123128.GA9761@quad> <CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com> <CABPqkBQSBKS+bnLhStzV4PTrE+Qrb1XyeR5FEyn4d+NFZrhuOQ@mail.gmail.com> <CAOJsxLE1L1ffZmuF+2+vYZMTXyvq00pOcP1xvGJuW0TqxQskrA@mail.gmail.com> <CABPqkBSpqNWJVhRh4bKRK5PGcCdZhzsJzyeQ53Mh4_7fVUm+wg@mail.gmail.com>
In-Reply-To: <CABPqkBSpqNWJVhRh4bKRK5PGcCdZhzsJzyeQ53Mh4_7fVUm+wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/23/2011 03:04 AM, Stephane Eranian wrote:
> On Fri, Sep 23, 2011 at 10:03 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> Hi Stephane!
>>
>> On Fri, Sep 23, 2011 at 10:31 AM, Stephane Eranian <eranian@google.com> wrote:
>>>> So how important is this information? The output is going to be somewhat
>>>> awkward for very large CPU counts... :-)
>>>>
>>> It is useful to determine how CPUs share caches for instance.
>>> It can get large but large, but the meta-data header is not printed by
>>> default, you need to request it with the -I option.
>>
>> Well, sure but it blocks rest of the interesting information too. It seems to me
>> that the CPU information could be truncated to some sane limit by default and
>> introduce a command line option for users that really want to see all of it.
>>
> Ok, so here is a proposal:
> - reorder the info so one liners appear first
> - display the "truncated" info by default (no option)
> - truncated: numa topo, cpu topo, stop after 4 cpus/nodes, print msg

Earlier I gave an example for a 2 socket, quad-core with hyperthreading
(16 cpus total):
    https://lkml.org/lkml/2011/9/6/355
The information is repetitive. It would be better to devise a way to
reduce the repetition versus truncate the information.

David


> to hint at -I option
> - use -I to print the extended header info report
> 
> That way we do no introduce two options just for the header information.
> 
> How about that instead?

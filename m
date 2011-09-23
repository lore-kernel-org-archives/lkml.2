Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1IWOJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:09:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab1IWOJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:09:19 -0400
Message-ID: <4E7C930B.4060505@gmail.com>
Date: Fri, 23 Sep 2011 08:09:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com, ak@linux.intel.com
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
References: <20110922123128.GA9761@quad> <CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com> <CABPqkBQSBKS+bnLhStzV4PTrE+Qrb1XyeR5FEyn4d+NFZrhuOQ@mail.gmail.com> <CAOJsxLE1L1ffZmuF+2+vYZMTXyvq00pOcP1xvGJuW0TqxQskrA@mail.gmail.com> <CABPqkBSpqNWJVhRh4bKRK5PGcCdZhzsJzyeQ53Mh4_7fVUm+wg@mail.gmail.com> <4E7C8B67.9030708@gmail.com> <CABPqkBTuc_jowJx0PqPPhcCuj6B5dqRaQNiZWiyhhHMN+NkLYg@mail.gmail.com>
In-Reply-To: <CABPqkBTuc_jowJx0PqPPhcCuj6B5dqRaQNiZWiyhhHMN+NkLYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/23/2011 07:40 AM, Stephane Eranian wrote:
> 
> 
> On Fri, Sep 23, 2011 at 3:36 PM, David Ahern <dsahern@gmail.com
> <mailto:dsahern@gmail.com>> wrote:
> 
> 
> 
>     On 09/23/2011 03:04 AM, Stephane Eranian wrote:
>     > On Fri, Sep 23, 2011 at 10:03 AM, Pekka Enberg
>     <penberg@cs.helsinki.fi <mailto:penberg@cs.helsinki.fi>> wrote:
>     >> Hi Stephane!
>     >>
>     >> On Fri, Sep 23, 2011 at 10:31 AM, Stephane Eranian
>     <eranian@google.com <mailto:eranian@google.com>> wrote:
>     >>>> So how important is this information? The output is going to be
>     somewhat
>     >>>> awkward for very large CPU counts... :-)
>     >>>>
>     >>> It is useful to determine how CPUs share caches for instance.
>     >>> It can get large but large, but the meta-data header is not
>     printed by
>     >>> default, you need to request it with the -I option.
>     >>
>     >> Well, sure but it blocks rest of the interesting information too.
>     It seems to me
>     >> that the CPU information could be truncated to some sane limit by
>     default and
>     >> introduce a command line option for users that really want to see
>     all of it.
>     >>
>     > Ok, so here is a proposal:
>     > - reorder the info so one liners appear first
>     > - display the "truncated" info by default (no option)
>     > - truncated: numa topo, cpu topo, stop after 4 cpus/nodes, print msg
> 
>     Earlier I gave an example for a 2 socket, quad-core with hyperthreading
>     (16 cpus total):
>        https://lkml.org/lkml/2011/9/6/355
>     The information is repetitive. It would be better to devise a way to
>     reduce the repetition versus truncate the information.
> 
> 
> I have modified the patch to NOT print the CPU, NUMA topology by
> default (but mentioned they are available with the -I option). The
> other bits of information are displayed systematically (no truncation).
> 
> What ways would you propose to still print the info is a less-verbose
> fashion?
> 

for example, sibling cores:
# CPU0 sibling cores  : 0,2,4,6,8,10,12,14

you don't need to print that info for CPUs 0,2,4,6,8,10,12,14. Just
once. Maybe just:

# CPU sibling cores  : 0,2,4,6,8,10,12,14

Similarly for the threads:
# CPU sibling threads: 0,8


That drops the output from 32 lines to 10.

# CPU sibling cores  : 0,2,4,6,8,10,12,14
# CPU sibling cores  : 1,3,5,7,9,11,13,15
# CPU sibling threads: 0,8
# CPU sibling threads: 1,9
# CPU sibling threads: 2,10
# CPU sibling threads: 3,11
# CPU sibling threads: 4,12
# CPU sibling threads: 5,13
# CPU sibling threads: 6,14
# CPU sibling threads: 7,15


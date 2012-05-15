Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2EOLHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:07:19 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44220 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab2EOLHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAKTCnz=0vihGLXQx+C_9399018eJ1hfRHUk21fE=2i_emLzBAw@mail.gmail.com>
References: <1336588657.26723.23.camel@andre>
	<CAKTCnz=0vihGLXQx+C_9399018eJ1hfRHUk21fE=2i_emLzBAw@mail.gmail.com>
Date: Tue, 15 May 2012 16:37:17 +0530
Message-ID: <CAKTCnznMGsrpqeRCRTPQApB84GD8FGUPL0fSK9JGysgYKtwVnA@mail.gmail.com>
Subject: Re: About cgroup memory limits
From: Balbir Singh <bsingharora@gmail.com>
To: Andre Nathan <andre@digirati.com.br>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 4:36 PM, Balbir Singh <bsingharora@gmail.com> wrote:
>
>
> On Thu, May 10, 2012 at 12:07 AM, Andre Nathan <andre@digirati.com.br>
> wrote:
>>
>> Hello
>>
>> I'm doing some tests with LXC and how it interacts with the memory
>> cgroup limits, more specifically the memory.limit_in_bytes control file.
>>
>> Am I correct in my understanding of the memory cgroup documentation[1]
>> that the limit set in memory.limit_in_bytes is applied to the sum of the
>> fields 'cache', 'rss' and 'mapped_file' in the memory.stat file?
>>
>> I am also trying to understand the values reported in memory.stat when
>> compared to the statistics in /proc/$PID/statm.
>>
>> Below is the sum of each field in /proc/$PID/statm for every process
>> running inside a test container, converted to bytes:
>>
>>       size  resident     share     text  lib       data  dt
>>  897208320  28741632  20500480  1171456    0  170676224   0
>>
>> Compare this with the usage reports from memory.stat (fields total_*,
>> hierarchical_* and pg* omitted):
>>
>> cache                     16834560
>> rss                       8192000
>> mapped_file               3743744
>> swap                      0
>> inactive_anon             0
>> active_anon               8192000
>> inactive_file             13996032
>> active_file               2838528
>> unevictable               0
>>
>> Is there a way to reconcile these numbers somehow? I understand that the
>> fields from the two files represent different things. What I'm trying to
>> do is to combine, for example, the fields from memory.stat to
>> approximately reach what is displayed by statm.
>>
>

Resending.. Plain text issues (sorry)

> cgroups accounting is different (sorry for that) from statm. From
> Documentation/filesystems/proc.txt
>
> Table 1-3: Contents of the statm files (as of 2.6.8-rc3)
>
> ..............................................................................
>  Field    Content
>  size     total program size (pages)            (same as VmSize in status)
>  resident size of memory portions (pages)       (same as VmRSS in status)
>  shared   number of pages that are shared       (i.e. backed by a file)
>  trs      number of pages that are 'code'       (not including libs;
> broken,
>                                                         includes data
> segment)
>  lrs      number of pages of library            (always 0 on 2.6)
>  drs      number of pages of data/stack         (including libs; broken,
>                                                         includes library
> text)
>  dt       number of dirty pages                 (always 0 on 2.6)
>
> ..............................................................................
>
> vmRSS accounting is different from RSS accounting in cgroups. I presume
> you acquired this data from process running in the cgroup? What does cat of
> tasks file within the cgroup show you? Ideally you want to make sure there
> is one task inside the cgroup to compare against /proc/$PID/statm and the
> data is collected from a task outside that cgroup
>
> Balbir

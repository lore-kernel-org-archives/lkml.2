Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2BERrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 12:47:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43900 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2BERrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 12:47:22 -0500
Message-ID: <4F2EC0AA.2090706@gmail.com>
Date: Sun, 05 Feb 2012 10:47:22 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Specifying some processes to record using perf
References: <CAL8zT=gX5=S9fd1MdYyYVYg+35anmK-aJwFj9fUiKNuMSb8n_w@mail.gmail.com> <CAL8zT=jXmSWbEQO2T2Kpp2_Yei5VJ+sGVt5U2vJwPo=6T2YY1g@mail.gmail.com> <4F2ABAC6.5060200@gmail.com> <4F2DBD1F.20909@gmail.com> <20120205142349.GE30158@infradead.org>
In-Reply-To: <20120205142349.GE30158@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/05/2012 07:23 AM, Arnaldo Carvalho de Melo wrote:
> Em Sat, Feb 04, 2012 at 04:19:59PM -0700, David Ahern escreveu:
>> On 02/02/2012 09:33 AM, David Ahern wrote:
>>>
>>> On 02/02/2012 08:52 AM, Jean-Michel Hautbois wrote:
>>>> Hi all,
>>>>
>>>> I am using perf and I have several process and threads to record.
>>>> I know that some threads in particular are interesting, and I don't
>>>> find a way to specify multiple threads in perf record.
>>>> The "-t" option takes only one thread IIUC.
>>
>> Found some time on the plane ride home to give this a shot. The attached
>> applies on top of the perf/core branch in:
>>
>>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
>>
>> You can specify multiple threads or multiple processing using a
>> comma-separated list. e.g., -t tid1,tid2,... or -p pid1,pid2,... (not both).
>>
>> It still needs more testing, but let me know how it works for what you need.
>>
>> Arnaldo: would you mind scanning this and see if there are any major
>> problems/objections with the approach?
> 
> It looks ok, but I wouldn't remove the existing specialized thread_map
> constructors, i.e. no need to first transform getpid() into an string to
> then pass to a generic constructor that would then back convert it into
> a pid_t :-)

Only perf-test does that; all the rest take pid/tid from the user.

> 
> Just add new constructors for CSV strings, like:
> 
> struct thread_map *thread_map__new_by_pids(const char *pid_list);
> 
> struct thread_map *thread_map__new_by_tids(const char *pid_list);
> 
> with the expected results, i.e. they would just tokenize and call the
> more basic constructors, at least in the by_pids, then concatenating the
> results, etc.

Ok. I can leave the existing ones. I did not want that interface to get
too complicated; with this change it will be easy to remove the 'or' and
allow a user to specify multiple thread ids and multiple process ids.

David

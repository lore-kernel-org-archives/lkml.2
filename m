Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab0JYAzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:55:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53760 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0JYAzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:55:48 -0400
Message-ID: <4CC4D5CA.3080409@cn.fujitsu.com>
Date: Mon, 25 Oct 2010 08:56:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 7/7] cgroups: Update documentation for bindable subsystems
References: <4CC146A4.9090505@cn.fujitsu.com>	<4CC14769.2000406@cn.fujitsu.com> <20101025093617.7de750c0.kamezawa.hiroyu@jp.fujitsu.com> <4CC4D4B9.3020807@cn.fujitsu.com>
In-Reply-To: <4CC4D4B9.3020807@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> KAMEZAWA Hiroyuki wrote:
>> On Fri, 22 Oct 2010 16:12:25 +0800
>> Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> Provide a usage example, and update the bind() callback API.
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>> ---
>>>  Documentation/cgroups/cgroups.txt |   26 +++++++++++++++++---------
>>>  1 files changed, 17 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
>>> index 190018b..5b5382a 100644
>>> --- a/Documentation/cgroups/cgroups.txt
>>> +++ b/Documentation/cgroups/cgroups.txt
>>> @@ -363,17 +363,23 @@ Note this will add ns to the hierarchy but won't remove memory or
>>>  cpuset, because the new options are appended to the old ones:
>>>  # mount -o remount,ns /dev/cgroup
>>>  
>>> +For some subsystems you can bind them to a mounted hierarchy or
>>> +remove them from it, even if there're sub-cgroups in it:
>>> +# mount -t cgroup -o freezer hier1 /dev/cgroup
>>> +# echo $$ > /dev/cgroup/my_cgroup
>>> +# mount -o freezer,cpuset hier1 /dev/cgroup
>>> +(failed)
>>> +# mount -o freezer,cpuacct hier1 /dev/cgroup
>>> +# mount -o cpuacct hier1 /dev/cgroup
>>> +
>>> +Note cpuacct should be sit in the default hierarchy before remount.
>>> +
>> Can this operation be used with noop cgroup ?
>> (IOW, perf cgroup can be attached to noop cgroup ?)
>>
> 
> Yes, you can. I've tested it.

But, wait. It stuck when I moved a task from a sub-cgroup to the root.
Need to dig more..

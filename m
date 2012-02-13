Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2BMRj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:39:57 -0500
Received: from nm5.access.bullet.mail.mud.yahoo.com ([66.94.237.206]:45689
	"HELO nm5.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755574Ab2BMRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:39:55 -0500
X-Yahoo-Newman-Id: 616822.95532.bm@smtp108.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KRBRAJ0VM1k3nYFZdSnCiI5U8MBrDsbwl9jmWgh7xp3kwsM
 lqQeYJgjhrbE65zd00LB1hXHXT4XQZOr8G96ruqsMdkbtKVlYUhwFKQGGYqa
 8hKKQl8t8OB2jaRPvR28ACbUECP9Zv0D9TMEUESrAfm8M_toGj_mICNCDMD3
 S.N4rBLli5bu3zxJMVsXY09UXL6KWKLdUzsppSyugupH1WjqkGicS8RQnEQA
 EBf.nD5BbIzWKAbV_2lc7OEvvnLhYDj9w6_BRptQX4WbOsJ29crtlu1yaV.f
 n22A_2e7Jw4s4HdmzlZGwO7M058D7BkhUevlpmzP7dWRPEmOWynYnZYouY7j
 Z7fk1Y0T89ckM7aKKwTzKTEoDau5TLdyrrc7qheXuUxz7gsoIT.UNdg0gYpz
 Dym.lngSnFY4w6iX_zaPPoRva7rCMGx28UWJKZMs.nBMM_NRtQZc-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F394AE9.8040104@schaufler-ca.com>
Date: Mon, 13 Feb 2012 09:39:53 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: Serge Hallyn <serge.hallyn@canonical.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>
Subject: Re: [PATCH 0/5] IPC: checkpoint/restore in userspace enhancements
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6> <4F356206.1080509@schaufler-ca.com> <4F38EE17.7090809@parallels.com> <20120213161135.GE5009@sergelap> <4F393EE7.4050805@parallels.com>
In-Reply-To: <4F393EE7.4050805@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/2012 8:48 AM, Stanislav Kinsbursky wrote:
> 13.02.2012 20:11, Serge Hallyn пишет:
>> Quoting Stanislav Kinsbursky (skinsbursky@parallels.com):
>>> 10.02.2012 22:29, Casey Schaufler пишет:
>>>> On 2/9/2012 10:01 AM, Stanislav Kinsbursky wrote:
>>>>> This patch set aimed to provide additional functionality for all 
>>>>> IPC objects,
>>>>> which is required for migration these objects by user-space 
>>>>> checkpoint/restore
>>>>> utils.
>>>>> The main problem here was impossibility to set up object id. This 
>>>>> patch set
>>>>> solves the problem in two steps:
>>>>> 1) Makes it possible to create new object (shared memory, 
>>>>> semaphores set or
>>>>> messages queue) with ID, equal to passed key.
>>>>> 2) Makes it possible to change existent object key.
>>>>
>>>> Is there any chance you might include the LSM data as well?
>>>>
>>>
>>> Sorry, but I don't understand your question.
>>> What is this "LSM"? Linux Shared Memory? If yes, and you mean SYSV
>>> IPC SHM, then where do you want to include it?
>>
>> He means linux security modules.  (see include/linux/security.h)
>
> Ok, thanks for explanation.
> Casey, what exactly you are asking about? Am I going to implement 
> security_*_set() functions?
>

The IPC objects are queer beasts in that they are both
volatile and persistent. If you restart a process that
uses IPC objects they may have to be recreated, which is
what your code is doing. If the system is using an LSM
there may be information attached to the IPC object that
can not be derived from the process being restarted.

That's a roundabout way of saying yes, you may need to
implement security_sem_set and friends
security_{sem,shm,msg}_[ge]et(). The good news is that
I know of at least one other project that is looking
to implement those functions for unrelated reasons.



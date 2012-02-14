Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2BNLeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:34:06 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:27018 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab2BNLeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:34:03 -0500
Message-ID: <4F3A4689.7030904@parallels.com>
Date: Tue, 14 Feb 2012 15:33:29 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
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
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6> <4F356206.1080509@schaufler-ca.com> <4F38EE17.7090809@parallels.com> <20120213161135.GE5009@sergelap> <4F393EE7.4050805@parallels.com> <4F394AE9.8040104@schaufler-ca.com>
In-Reply-To: <4F394AE9.8040104@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

13.02.2012 21:39, Casey Schaufler пишет:
> On 2/13/2012 8:48 AM, Stanislav Kinsbursky wrote:
>> 13.02.2012 20:11, Serge Hallyn пишет:
>>> Quoting Stanislav Kinsbursky (skinsbursky@parallels.com):
>>>> 10.02.2012 22:29, Casey Schaufler пишет:
>>>>> On 2/9/2012 10:01 AM, Stanislav Kinsbursky wrote:
>>>>>> This patch set aimed to provide additional functionality for all
>>>>>> IPC objects,
>>>>>> which is required for migration these objects by user-space
>>>>>> checkpoint/restore
>>>>>> utils.
>>>>>> The main problem here was impossibility to set up object id. This
>>>>>> patch set
>>>>>> solves the problem in two steps:
>>>>>> 1) Makes it possible to create new object (shared memory,
>>>>>> semaphores set or
>>>>>> messages queue) with ID, equal to passed key.
>>>>>> 2) Makes it possible to change existent object key.
>>>>>
>>>>> Is there any chance you might include the LSM data as well?
>>>>>
>>>>
>>>> Sorry, but I don't understand your question.
>>>> What is this "LSM"? Linux Shared Memory? If yes, and you mean SYSV
>>>> IPC SHM, then where do you want to include it?
>>>
>>> He means linux security modules.  (see include/linux/security.h)
>>
>> Ok, thanks for explanation.
>> Casey, what exactly you are asking about? Am I going to implement
>> security_*_set() functions?
>>
>
> The IPC objects are queer beasts in that they are both
> volatile and persistent. If you restart a process that
> uses IPC objects they may have to be recreated, which is
> what your code is doing. If the system is using an LSM
> there may be information attached to the IPC object that
> can not be derived from the process being restarted.
>

Hmmm. If I understood you right, you are taking about kernel_ipc_perm->security 
data migration, which is not supported yet.
Am I right?
If yes, then, in general, it would be great to migrate security data some day. 
It you feel, that new interfaces are not suitable for security migration and you 
can give me an advice how to update them - then it would be great.

> That's a roundabout way of saying yes, you may need to
> implement security_sem_set and friends
> security_{sem,shm,msg}_[ge]et(). The good news is that
> I know of at least one other project that is looking
> to implement those functions for unrelated reasons.

What project?

-- 
Best regards,
Stanislav Kinsbursky

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0HRJP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0HRJPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:15:55 -0400
Message-ID: <4C6BA5C7.5010207@redhat.com>
Date: Wed, 18 Aug 2010 17:20:07 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 2/2] Makefile: "make kernelrelease" should show the correct
 full kernel version
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain> <20100628030516.5187.49089.sendpatchset@localhost.localdomain> <4C6B88A5.4050305@inria.fr> <4C6B957C.1090308@redhat.com> <4C6B9BFE.1030308@inria.fr> <4C6BA077.2080306@redhat.com> <4C6B9F53.6040100@inria.fr>
In-Reply-To: <4C6B9F53.6040100@inria.fr>
Content-Type: multipart/mixed;
 boundary="------------010208070102010206090905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010208070102010206090905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

On 08/18/10 16:52, Brice Goglin wrote:
> Le 18/08/2010 10:57, Cong Wang a écrit :
>> On 08/18/10 16:38, Brice Goglin wrote:
>>> Le 18/08/2010 10:10, Cong Wang a écrit :
>>>> On 08/18/10 15:15, Brice Goglin wrote:
>>>>> This patch (actually 01ab17887 in 2.6.36-rc1) reveals what looks
>>>>> like a
>>>>> problem to me: make kernelrelease always regenerates
>>>>> include/config/kernel.release even if it's already more recent than
>>>>> include/config/auto.conf. Is this the expected behavior? Do we really
>>>>> need include/config/kernel.release to depend on FORCE?
>>>>>
>>>>
>>>> I think so, because "LOCALVERSION=" can be given from command line,
>>>> so we need to regenerate it.
>>>>
>>>> Or am I missing your point here?
>>>>
>>>
>>> Interesting. I assumed "make kernelrelease" was mainly here to display
>>> the release string (which means you would not need write access to the
>>> kernel build dir). And indeed make help says:
>>>     kernelrelease      - Output the release version string
>>> Right now, it looks like "update the version string and by the way
>>> display it too" (and you need write access).
>>>
>>
>> I believe you will also need write access even without this patch,
>> if you compile a fresh kernel. So your assumption is not correct.
>>
>
> If I revert 01ab17887f4, I don't need write access. Things always worked
> fine before 2.6.36 as far I remember.
>

Ah, I forgot Michal checked in a slightly different patch with mine. :)

Does the attached patch work for you?


---
Signed-off-by: WANG Cong <amwang@redhat.com>

--------------010208070102010206090905
Content-Type: text/x-patch;
 name="makefile-not-regenerate-release.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="makefile-not-regenerate-release.diff"

diff --git a/Makefile b/Makefile
index f3bdff8..25da252 100644
--- a/Makefile
+++ b/Makefile
@@ -1408,8 +1408,8 @@ checkstack:
 	$(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
 	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
 
-kernelrelease: include/config/kernel.release
-	@echo $(KERNELRELEASE)
+kernelrelease:
+	@echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
 
 kernelversion:
 	@echo $(KERNELVERSION)

--------------010208070102010206090905--

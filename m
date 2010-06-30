Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0F3Kf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:35:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0F3Kf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:35:27 -0400
Message-ID: <4C2B1EE0.2080301@redhat.com>
Date: Wed, 30 Jun 2010 18:39:28 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] Makefile: "make kernelrelease" should show the correct
 full kernel version
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain> <20100628030516.5187.49089.sendpatchset@localhost.localdomain> <20100629121315.GA13335@sepie.suse.cz>
In-Reply-To: <20100629121315.GA13335@sepie.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/10 20:13, Michal Marek wrote:
> On Sun, Jun 27, 2010 at 11:01:06PM -0400, Amerigo Wang wrote:
>> From: Amerigo Wang<amwang@redhat.com>
>> Date: Mon, 28 Jun 2010 10:45:21 +0800
>>
>> After commit 85a256d8e0116c8f5ad276730830f5d4d473344d, 'make kernelrelease' doesn't
>> show the correct full kernel version. This patch fixes it, 'make kernelrelease' will
>> show the same version name with the one you finally get.
>>
>> Cc: David Rientjes<rientjes@google.com>
>> Cc: Michal Marek<mmarek@suse.cz>
>> Signed-off-by: Amerigo Wang<amwang@redhat.com>
>> ---
>>   Makefile |    5 ++---
>>   1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 710f91c..2b517a1 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -414,7 +414,7 @@ endif
>>   no-dot-config-targets := clean mrproper distclean \
>>   			 cscope TAGS tags help %docs check% \
>>   			 include/linux/version.h headers_% \
>> -			 kernelrelease kernelversion
>> +			 kernelversion
>>
>>   config-targets := 0
>>   mixed-targets  := 0
>> @@ -1468,8 +1468,7 @@ checkstack:
>>   	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
>>
>>   kernelrelease:
>> -	$(if $(wildcard include/config/kernel.release), $(Q)echo $(KERNELRELEASE), \
>> -	$(error kernelrelease not valid - run 'make prepare' to update it))
>> +	@echo $(kernelrelease)
>>   kernelversion:
>>   	@echo $(KERNELVERSION)
>
> AFAICS it was broken even before 85a256d. Nevertheless, the patch is
> correct, but conflicts with 0915512 in the kbuild tree. What about this
> one?
>

Hmm, I am not sure. IIRC, my first try was also using KERNELRELEASE but it
didn't work. Note, I may remember wrongly. :)

Have you tested it? Sorry that currently I don't have time to test it, I am
quite busy with other stuffs...

Thanks!

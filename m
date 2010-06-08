Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0FHGhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:37:32 -0400
Received: from daytona.panasas.com ([67.152.220.89]:62878 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751918Ab0FHGha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:37:30 -0400
Message-ID: <4C0DE526.40504@panasas.com>
Date: Tue, 08 Jun 2010 09:37:26 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic - two for the
 price of one - No thanks
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DDAA6.8080002@panasas.com> <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 06:37:29.0286 (UTC) FILETIME=[10FABE60:01CB06D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 09:18 AM, David Rientjes wrote:
> On Tue, 8 Jun 2010, Boaz Harrosh wrote:
> 
>>>> I already have my:
>>>>  VERSION = 2
>>>>  PATCHLEVEL = 6
>>>>  SUBLEVEL = 35
>>>> -EXTRAVERSION = -rc2
>>>> +EXTRAVERSION = -rc2-my_tree
>>>>
>>>
>>> You shouldn't be using EXTRAVERSION for this purpose, you should be 
>>> passing LOCALVERSION=my_tree to make.
>>>
>>
>> That will not work because the way I run make is out of my control. Every
>> one in the working group has his system. The Makefile is part of the
>> public git tree, so every one will get the same identification without
>> any confusion with Vanilla kernel, or what was compiled.
>>
> 
> If everyone using that tree wants the same version string for that kernel, 
> use CONFIG_LOCALVERSION="-my_tree" in your .config and use "make 
> LOCALVERSION=".

That does not work I tried LOCALVERSION is checked for emptiness. So the
"plus" is added just the same. I tried:

$ make			# gets a plus
$ make LOCALVERSION=""	# same plus

CONFIG_LOCALVERSION will not work because it, too, is not in the git. I need
something that everyone can get by checkout. (The config file is usually a
distro config with make oldconfig)

> 
>>> Unless it's a vanilla 2.6.35-rc2 kernel, it's inaccurate to persent it as 
>>> 2.6.35-rc2; you'll need to pass LOCALVERSION to make to identify this as a 
>>> non-vanilla kernel.
>>
>> What are we lawyers? come on. And I do not have that problem! The output will
>> not be 2.6.35-rc2 as you fear. It will be 2.6.35-rc2-my-tree-my-version.
> 
> That's because you're using EXTRAVERSION which is also used upstream to 
> describe kernel releases (stable, rc, mm, etc).
> 

That's why it is perfect. Because I have that patch as first in my tree that
changes that in Makefile. Then from time to time when I rebase I get the
conflict with Linus change of the name, and have the privilege to specify how
this is a different tree, with a different name and version. It is all git work
no external factors. (That I will keep, regardless of plus or no plus)

And you have not answered my question:
  What does the CONFIG_LOCALVERSION_AUTO give me? the name is changed regardless
  so now it has become. Min-Auto-Name or Informative-Auto-Name. It used to be
  Auto-name-yes or Auto-Name-no. Please change the config name to reflect the choice
  we actually have. (And keep the old config because we need the original choice)

>> Please stop this *none-sense* this is not your place to mandate my Kernel name. If
>> I'm forced to have an external Makefile I can just "mv" what ever name I choose.
>> The Kernel name is an ABI you have just broken that, You must revert it ASAP.
>>
> 
> You still have the tools available to do everything you once did.

No! how? I couldn't find how please specify exact commands to use.

Boaz

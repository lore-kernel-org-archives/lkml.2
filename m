Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0FHFwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 01:52:42 -0400
Received: from daytona.panasas.com ([67.152.220.89]:34986 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751571Ab0FHFwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 01:52:41 -0400
Message-ID: <4C0DDAA6.8080002@panasas.com>
Date: Tue, 08 Jun 2010 08:52:38 +0300
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
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 05:52:40.0612 (UTC) FILETIME=[CE67A640:01CB06CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 10:45 PM, David Rientjes wrote:
> On Mon, 7 Jun 2010, Boaz Harrosh wrote:
> 
>> Rrrr. If I wanted CONFIG_LOCALVERSION_AUTO, I would use that one. At least
>> it is actually useful and informative.
>>
>> I already have my:
>>  VERSION = 2
>>  PATCHLEVEL = 6
>>  SUBLEVEL = 35
>> -EXTRAVERSION = -rc2
>> +EXTRAVERSION = -rc2-my_tree
>>
> 
> You shouldn't be using EXTRAVERSION for this purpose, you should be 
> passing LOCALVERSION=my_tree to make.
> 

That will not work because the way I run make is out of my control. Every
one in the working group has his system. The Makefile is part of the
public git tree, so every one will get the same identification without
any confusion with Vanilla kernel, or what was compiled.

>> Which is managed by a git tree (for everybody based on my tree)
>>
>> At least give us a way out with:
>> CONFIG_LOCALVERSION_NO_AUTO_IM_REALLY_STUPID=y way out.
>>
>> or EXTRAVERSION != $(git version)
>>
>> But don't leave us cold in the woods like that. (What if I remove the git tree altogether, move to svn)
>>
>> If I can shoot my self in the foot, it does not mean Government should not issue any more
>> gun licenses.
>>
>> I already have my outer Makefile system that makes sure I don't forget to compile, or
>> "did I install this Kernel or not". Please let us have a way out?
>>
> 
> Unless it's a vanilla 2.6.35-rc2 kernel, it's inaccurate to persent it as 
> 2.6.35-rc2; you'll need to pass LOCALVERSION to make to identify this as a 
> non-vanilla kernel.

What are we lawyers? come on. And I do not have that problem! The output will
not be 2.6.35-rc2 as you fear. It will be 2.6.35-rc2-my-tree-my-version.
A person is checking out my tree will get my version string and the output
name is well defined, and separate from Vanilla Kernel. So even the layers are
happy. (That said, insert the: "I have a right to be stupid ..." mantra)

I don't get it. What is that CONFIG_LOCALVERSION_AUTO. It has become a *no-choice*
option. The system now tells me: "I will poke in your system, if I find it under git,
I slave it. Your choice is to have an ugly "+" sign or a more informative name based
on actual commit number". But that is no-choice don't you see?

Please stop this *none-sense* this is not your place to mandate my Kernel name. If
I'm forced to have an external Makefile I can just "mv" what ever name I choose.
The Kernel name is an ABI you have just broken that, You must revert it ASAP.

Boaz !

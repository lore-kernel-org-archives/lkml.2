Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0FIHyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:54:13 -0400
Received: from daytona.panasas.com ([67.152.220.89]:32671 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755801Ab0FIHyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:54:12 -0400
Message-ID: <4C0F489F.4020204@panasas.com>
Date: Wed, 09 Jun 2010 10:54:07 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: kbuild: Fix the breakage caused by "improve version string logic"
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DFFFF.1010704@panasas.com> <alpine.DEB.2.00.1006080200190.18052@chino.kir.corp.google.com> <4C0E17F0.5010902@panasas.com> <alpine.DEB.2.00.1006082352120.30606@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1006082352120.30606@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2010 07:54:10.0042 (UTC) FILETIME=[F1A825A0:01CB07A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 09:55 AM, David Rientjes wrote:
> On Tue, 8 Jun 2010, Boaz Harrosh wrote:
> 
>> What is a tagged commit:
>>
>> [my_tree] $ git branch
>> *master
>> [my_tree] $ git tag v2.6.35-rc2-my-tree
>> [my_tree] $ cat localversion-my-tree
>> -my-tree
>>
>> I still get: DEPMOD 2.6.35-rc2-my-tree+
>>
>> How to solve? please specify.
>>
> 
> You need to use git tag -a.
> 

Right, I got that

>> In my tree there is 2.6.35-rc2-my-tree so it cannot be mistaken with
>> Linus tree.
>>
> 
> Just because you have appended "-my-tree" to the version string does not 
> mean it is not vanilla 2.6.35-rc2.  You could append information such as 
> that just for a different config, for instance.  

No, this is all naming convention. Just like the '+' is. If it was a config
thing then it would be added via CONFIG_LOCALVERSION and *appended* to any
compilation using that config. From a git tree you get added the localversion*
file that gets pulled by a checkout. and so on. So at a glance I know that
the presence of my_tree was added because it is from my tree. They are all
chained and ordered so we know exactly what contributed what.

> The `+' modifies the base 
> kernel version (2.6.35-rc2), not the string itself or whatever you choose 
> to add to it.
> 

Not, correct. As you yourself explained. The `+' modifies any Kernel that
is not a "tag -a" and/or modified from the tree it derives from.
Base kernel version has nothing to do with it.

>>> As mentioned previously, you can easily suppress that from being added by 
>>> using "make LOCALVERSION=-foo" to create a 2.6.35-rc2-foo kernel when you 
>>> do not have CONFIG_LOCALVERSION_AUTO enabled.  You already found that you 
>>> cannot pass an empty LOCALVERSION string, so it must be something to 
>>> identify itself as unique from vanilla 2.6.35-rc2.
>>>
>>
>> As mentioned previously this is not an option I do not have git control
>> over how this gets compiled.
>>
> 
> If your git repository is publically accessible, it is very simple to tag 
> commits that you want your users to pull from to indicate it's a 
> "release".  That allows you to determine whether other users have extra 
> commits on top of your release when they send you bug reports, for 
> example, which is quite helpful.

Sigh, I give up. Let me spell it out for you once more and I'll not mention
this again:
  "For multitude of reasons, there are times that even when running from
   a git tree, I wish to compile a Kernel as if it's from a tar-ball. .i.e
   Don't poke in my git tree for this compilation."

Because I'm cross compiling, because I'm bisecting, because my scripts and
environment demand specific names, because i need to save space and time...

But it seems I will not be granted my wish. I'll go damage my
scripts/setlocalversion and be done with this.

Thanks
Boaz

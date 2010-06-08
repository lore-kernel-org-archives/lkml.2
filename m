Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0FHKTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 06:19:45 -0400
Received: from daytona.panasas.com ([67.152.220.89]:59342 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754307Ab0FHKTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 06:19:44 -0400
Message-ID: <4C0E193D.6050005@panasas.com>
Date: Tue, 08 Jun 2010 13:19:41 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: kbuild: Fix the breakage caused by "improve version string logic"
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DFFFF.1010704@panasas.com> <alpine.DEB.2.00.1006080200190.18052@chino.kir.corp.google.com> <4C0E17F0.5010902@panasas.com>
In-Reply-To: <4C0E17F0.5010902@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 10:19:43.0949 (UTC) FILETIME=[1D0ED7D0:01CB06F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 01:14 PM, Boaz Harrosh wrote:
> On 06/08/2010 12:13 PM, David Rientjes wrote:
>> On Tue, 8 Jun 2010, Boaz Harrosh wrote:
>>
>>>
>>> The patch: 85a256d8e0116c8f5ad276730830f5d4d473344d
>>> 	Author: David Rientjes <rientjes@google.com>
>>> 	Title: kbuild: improve version string logic
>>>
>>> Broke none Linus trees that supply their own version string and
>>> tag system via a presence of a localversion* file at the Kernel's
>>> root subdirectory.
>>>
>>> After This patch. The "+" (plus) is not added if a localversion*
>>> file is present or a CONFIG_LOCALVERSION is configured.
>>>
>>
>> The only reason the `+' is being appended to your version string is 
>> because your scm is reporting that there have been commits to the tree 
>> since the last release; for git, that means anything that isn't at a 
>> tagged commit.
>>
> 
> What is a tagged commit:
> 
> [my_tree] $ git branch
> *master
> [my_tree] $ git tag v2.6.35-rc2-my-tree

OK now I get it I need:
$ git tag -a v2.6.35-rc2-my-tree

I never used the -a before though no one complained. What else
am I missing?

Boaz

> [my_tree] $ cat localversion-my-tree
> -my-tree
> 
> I still get: DEPMOD 2.6.35-rc2-my-tree+
> 
> How to solve? please specify.
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab0FQPpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:45:51 -0400
Received: from daytona.panasas.com ([67.152.220.89]:41674 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932617Ab0FQPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:45:49 -0400
Message-ID: <4C1A432B.3020709@panasas.com>
Date: Thu, 17 Jun 2010 11:45:47 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Makefile asking for mrproper on new checkout with KBUILD_OUTPUT
References: <4C194AB2.7050707@panasas.com> <4C19E01F.2010403@suse.cz>
In-Reply-To: <4C19E01F.2010403@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2010 15:45:48.0434 (UTC) FILETIME=[281E1720:01CB0E34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 04:43 AM, Michal Marek wrote:
> On 17.6.2010 00:05, Boaz Harrosh wrote:
>>
>> I get this problem: When a few Header files are changed, like when doing
>> a git checkout the Makefile is complaining about mrproper needed.
>>
>> Now I'm building a:
>> 	make ARCH=arch KBUILD_OUTPUT=.build_arch/
>>
>> But a: 
>> 	make ARCH=arch KBUILD_OUTPUT=.build_arch/ mrproper
>>
>> Will not help. What the Makefile wants is a:
>> 	make mrproper
>>
>> doing the "make mrproper" does solves it.
>> It used to be fine, I'm not sure when it started to break.
>>
>> How can I debug this to see what is the offending files?
> 
> The makefile errors out if the source directory is configured (*),
> because having random object files in the source directory would confuse
> the VPATH build.
> 
> (*) Means: either .config or include/config exists
> 

OK, Thanks. What I see is that when I do:
make ARCH=um KBUILD_OUTPUT=.build_um INSTALL_MOD_PATH=$FS_LOCAL_MOUNT modules_install

I get a phantom empty include/config directory. The INSTALL_MOD_PATH=$FS_LOCAL_MOUNT is
because I'm installing into the uml image file.

This only happens when some include/... header files changed since the last make.
The "make ARCH=um KBUILD_OUTPUT=.build_um" stage is fine only after the modules_install
stage it appears.

> Michal

Thanks
Boaz

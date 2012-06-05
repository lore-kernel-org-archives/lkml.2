Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2FERYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab2FERYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:24:38 -0400
Message-ID: <4FCE40C3.5040902@redhat.com>
Date: Tue, 05 Jun 2012 14:24:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <borislav.petkov@amd.com>, linux-edac@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 5 (amd64_edac)
References: <20120605133000.f2d21fb02881ef54a7bfe728@canb.auug.org.au> <4FCE333F.6060207@xenotime.net> <20120605171704.GP13495@aftab.osrc.amd.com>
In-Reply-To: <20120605171704.GP13495@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-06-2012 14:17, Borislav Petkov escreveu:
> On Tue, Jun 05, 2012 at 09:26:39AM -0700, Randy Dunlap wrote:
>> On 06/04/2012 08:30 PM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> There will be no linux-next release tomorrow.
>>>
>>> Changes since 20120604:
>>
>>
>>
>> on x86_64:
>>
>> drivers/edac/amd64_edac_inj.o: In function `amd64_remove_sysfs_dbg_files':
>> amd64_edac_inj.c:(.text+0x420): multiple definition of `amd64_remove_sysfs_dbg_files'
>> drivers/edac/amd64_edac.o:amd64_edac.c:(.text+0x3d60): first defined here
>> make[3]: *** [drivers/edac/amd64_edac_mod.o] Error 1
> 
> Doesn't trigger on latest linus. But Mauro has a bunch of patches
> touching these parts, can you try reverting if it is in linux-next, the
> one below:
> 
> commit faf20d4e226c53a963c384d36d8aa82c77be6dfb
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Wed Mar 21 14:00:44 2012 -0300
> 
>     amd64_edac: convert sysfs logic to use struct device
>     
>     Now that the EDAC core supports struct device, there's no sense
>     on having any logic at the EDAC core to simulate it. So, instead
>     of adding such logic there, change the logic at amd64_edac to
>     use it.
>     
>     Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
>     Cc: Doug Thompson <norsk5@yahoo.com>
>     Cc: Borislav Petkov <borislav.petkov@amd.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Thanks.
> 

It is probably just a Kconfig issue. I'll prepare a patch fixing it,
posting it soon.

Thanks,
Mauro


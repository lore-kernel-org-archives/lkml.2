Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2BBJLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:11:12 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2BBJLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:11:08 -0500
Message-ID: <4F2A5326.3060403@nod.at>
Date: Thu, 02 Feb 2012 10:11:02 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: artem.bityutskiy@linux.intel.com
CC: dwmw2@infradead.org, kyungmin.park@samsung.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MTD: Refine HAS_IOMEM dependency
References: <1327512102-22447-1-git-send-email-richard@nod.at> <1328173667.28171.146.camel@sauron.fi.intel.com>
In-Reply-To: <1328173667.28171.146.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.02.2012 10:07, Artem Bityutskiy wrote:
> On Wed, 2012-01-25 at 18:21 +0100, Richard Weinberger wrote:
>> Making the entire mtd subsystem depend on HAS_IOMEM is a bit overkill.
>> HAS_IOMEM is only needed for real devices drivers.
>> nandsim and friends are perfectly usable on systems without IO memory.
>>
>> I'm my case I'm using nandsim on UML to do some UBI and JFFS2 development.
>>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>
> Could you please work on this patch some more and make sure it does not
> break s390 build (it does now).

Sure!

> Download the s390 cross-compiler from here:
> http://kernel.org/pub/tools/crosstool/files/bin/
>
> I used this one:
> http://kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.0/x86_64-gcc-4.6.0-nolibc_s390x-linux.tar.bz2
>
> I built the kernel with arch/s390/defconfig - it is out of date a bit,
> but the kernel compiles with it.
>
> Then I applied your patch and enabled all the available MTD options and
> failed to build it. I've attached this .config file. Here is the command
> line I used to build the kernel for s390x:
>
> $ make ARCH=s390 CROSS_COMPILE=s390x-linux-
> O=/home/dedekind/space/kernel-builds/l2-mtd-s390 -j16
>
> The .config was put to /home/dedekind/space/kernel-builds/l2-mtd-s390,
> obviously, and the path to the s390x-linux-* tools were in my PATH
> environment variable.
>
> There many errors, here is just one example:
>
> make[4]: *** [drivers/mtd/lpddr/lpddr_cmds.o] Error 1
> /home/dedekind/git/l2-mtd/include/linux/mtd/map.h:407:3: error: implicit declaration of function 'memcpy_fromio' [-Werror=implicit-function-declaration]
> make[3]: *** [drivers/mtd/lpddr] Error 2
> make[3]: *** Waiting for unfinished jobs....

Okay, S390 does not have memcpy_fromio(). :-\

Thanks,
//richard

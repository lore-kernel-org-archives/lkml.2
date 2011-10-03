Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1JCQDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:03:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:65088 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab1JCQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:03:38 -0400
Message-ID: <4E89DCC7.4010703@windriver.com>
Date: Mon, 3 Oct 2011 12:03:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@gmail.com>, <linux-kernel@vger.kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: samsung: s3c-i2s-v2.c needs module.h
References: <1317562466.4996.2.camel@phoenix> <20111002182605.GC2857@opensource.wolfsonmicro.com> <CAF+7xWkfTJXwt1uUtXgkh5Go9yxWasdM5a3DuLnii_5LqB00UQ@mail.gmail.com> <20111003103026.GB23811@sirena.org.uk>
In-Reply-To: <20111003103026.GB23811@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-10-03 06:30 AM, Mark Brown wrote:
> On Mon, Oct 03, 2011 at 08:17:21AM +0800, Axel Lin wrote:
>> 2011/10/3 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> 
>>> What tree is this for? ?My primary development platform is based on this
>>> driver, I'd expect to have noticed any build issues and I rather suspect
>>> this isn't what you're supposed to do after all the module.h stuff has
>>> settled down.
> 
>> I got the build error on linux-next (20110930).
> 
> That's exactly what I'm running at the minute with no problem...

Then I'm guessing you don't have the option for it enabled (as
the s3c2410_defconfig doesn't enable it, it seems).

I reproduced it with the following commands:

   28  git checkout next-20110930
   29  mkdir ../arm-sam
   30  make O=../arm-sam s3c2410_defconfig
   31  nice make O=../arm-foo/ sound/soc/samsung/s3c-i2s-v2.o

Thanks Axel, I'll squish this into the commit that adds module.h
to all the other sound drivers that have it missing.

Paul.



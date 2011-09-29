Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1I2NHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:07:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:16421 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab1I2NHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,461,1312182000"; 
   d="scan'208";a="56939884"
Subject: Re: [PATCHv2] fat: don't use custom hex_to_bin()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 29 Sep 2011 16:07:21 +0300
In-Reply-To: <87bou5inkk.fsf@devron.myhome.or.jp>
References: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
	 <542eeafb16d173360eb79f8188f967cc3dcc9252.1317124046.git.andriy.shevchenko@linux.intel.com>
	 <87hb3xj41s.fsf@devron.myhome.or.jp>
	 <CAHp75Vcdnx28i0s4sKUf+MCruMNq-zdX55f45TcTR7AcO4foSw@mail.gmail.com>
	 <87bou5inkk.fsf@devron.myhome.or.jp>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317301641.2676.120.camel@smile>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 08:15 +0900, OGAWA Hirofumi wrote: 
> Andy Shevchenko <andy.shevchenko@gmail.com> writes:
> 
> > Actually here we will change endianess.
> > So, my question is what endianess is right here? If the original code
> > okay, then patch should be rewritten like this:
> >
> >      rc = hex2bin(op++, ip + 3, 1);
> >      if (rc < 0)
> >           return -EINVAL;
> >
> >      rc = hex2bin(op++, ip + 1, 1);
> >      if (rc < 0)
> >           return -EINVAL;
> 
> Original code may work only for little endian. Well, anyway, the output
> should be wchar_t (u16) of native endian.

> So, I think it should be something like
> 
> 	u8 uc[2];
> 	if (hex2bin(uc, ip + 1, 2) < 0)
>         	return -EINVAL;
> 	*(wchar_t *)op = uc[0] << 8 | uc[1];
> This should be readable more.
It might be so, but it's not okay to do such constructions in C

fs/fat/namei_vfat.c:535:1: warning: ISO C90 forbids mixed declarations
and code [-Wdeclaration-after-statement]

So, I will resend patch as I proposed with additional comments.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

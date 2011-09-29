Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1I2Oyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:54:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:2868 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab1I2Oya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:54:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,461,1312182000"; 
   d="scan'208";a="72119162"
Subject: Re: [PATCHv2] fat: don't use custom hex_to_bin()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 29 Sep 2011 17:54:00 +0300
In-Reply-To: <87ipob8l4l.fsf@devron.myhome.or.jp>
References: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
	 <542eeafb16d173360eb79f8188f967cc3dcc9252.1317124046.git.andriy.shevchenko@linux.intel.com>
	 <87hb3xj41s.fsf@devron.myhome.or.jp>
	 <CAHp75Vcdnx28i0s4sKUf+MCruMNq-zdX55f45TcTR7AcO4foSw@mail.gmail.com>
	 <87bou5inkk.fsf@devron.myhome.or.jp> <1317301641.2676.120.camel@smile>
	 <87ipob8l4l.fsf@devron.myhome.or.jp>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317308040.2676.124.camel@smile>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 23:43 +0900, OGAWA Hirofumi wrote: 
> I guess you just did copy&paste. "u8 uc[2];" part should be before
> statement as C90.
> 
> I.e.
> 
> 				if (escape && (*ip == ':')) {
>                                 	u8 uc[2];
> 
> 					if (i > len - 5)
> 						return -EINVAL;
> 
> 					if (hex2bin(uc, ip + 1, 2) < 0)
> 						return -EINVAL;
> 					*(wchar_t *)op = uc[0] << 8 | uc[1];
Actually, why do not use 
*(wchar_t *)op++ = ... 
instead of additional op+=2?

> 
> 					op += 2;
> 					ip += 5;
> 					i += 5;
> 				} else {
> 
> This should be work?
Oh, my bad! So much minor mistakes last time. Really need vacation.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
